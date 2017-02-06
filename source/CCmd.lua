local function save_value(msg, name, value)
  if (not name or not value) then
    return  reply_msg(msg.id,"خطا!\nروش استفاده صحیح از این دستور به صورت زیر است\n\n<code>دستور متن پاسخ</code>",ok_cb,false)
  end
  local hash = nil
  if msg.to.type == 'chat' or msg.to.type == 'channel'  then
    hash = 'chat:'..msg.to.id..':variables'
  end
  if hash then
    redis:hset(hash, name, value)
    return reply_msg(msg.id,"دستور جدید ثبت شد!\nدستور فقط قابل استفاده در این گروه میباشد...\n\nدستور تنظیم شده: \n/"..name.."\n_________________\nجواب تنظیم شده برای دستور:\n"..value,ok_cb,false)
  end
end

local function save_gvalue(msg, name, value)
  if (not name or not value) then
    return  reply_msg(msg.id,"خطا!\nروش استفاده صحیح از این دستور به صورت زیر است\n\n<code>دستور متن پاسخ</code>",ok_cb,false)
  end
  local hash = nil
    hash = 'g:variables'
  if hash then
    redis:hset(hash, name, value)
    return reply_msg(msg.id,"دستور جدید ثبت شد!\nدستور قابل استفاده در همه ی گروه ها میباشد...\n\nدستور تنظیم شده: \n/"..name.."\n_________________\nجواب تنظیم شده برای دستور:\n"..value,ok_cb,false)
  end
end

local function del_value(msg, name, value)
  if msg.to.type == 'chat' or msg.to.type == 'channel'  then
    hash = 'chat:'..msg.to.id..':variables'
  end
  if hash then
    redis:del(hash, name)
    return "دستور /"..name.." با موفقیت حذف شد!"
  end
end

local function del_gvalue(msg, name, value)
  if msg.to.type == 'chat' or msg.to.type == 'channel'  then
    hash = 'g:variables'
  end
  if hash then
    redis:del(hash, name)
    return "دستور /"..name.." با موفقیت حذف شد!"
  end
end

local function grp_cmds(msg)
    return 'chat:'..msg.to.id..':variables'
end 

local function gl_cmds(msg)
    return 'g:variables'
end 

local function group_cmds(msg)
  local hash = grp_cmds(msg)
  if hash then
    local names = redis:hkeys(hash)
    local text = 'دستور های تنظیم شده برای این گروه:\n\n'
    for i=1, #names do
      text = text..'> /'..names[i]..'\n'
    end
    return reply_msg(msg.id,text,ok_cb,false)
	else
	return 
  end
end

local function global_cmds(msg)
  local hash = gl_cmds(msg)
  if hash then
    local names = redis:hkeys(hash)
    local text = 'دستور های تنظیم شده برای تمامی گروه ها:\n\n'
    for i=1, #names do
      text = text..'> /'..names[i]..'\n'
    end
    return reply_msg(msg.id,text,ok_cb,false)
	else
	return 
  end
end

local function run(msg, matches)

if matches[1] == 'c command' and permissions(msg.from.id, msg.to.id, "settings") then
   redis:set("cmdset:"..msg.to.id..":"..msg.from.id, "send cmd")
   return reply_msg(msg.id,'حالا دستور و جوابی که میخوای تنظیم شه رو به صورت زیر ارسال کن\n\nدستور جواب\nمثال:\n<code>/creator @MehdiHS</code>',ok_cb,false)
end

if matches[1] == 'c global command' and is_sudo(msg) then
   redis:set("cmdgset:"..msg.to.id..":"..msg.from.id, "send gcmd")
   return reply_msg(msg.id,'حالا دستور و جوابی که میخوای تنظیم شه رو به صورت زیر ارسال کن\n\nدستور جواب\nمثال:\n<code>/creator @MehdiHS</code>',ok_cb,false)
end

local hash1 = "cmdset:"..msg.to.id..":"..msg.from.id
if redis:get(hash1) == 'send cmd' then
  local name = string.sub(matches[1], 1, 50)
  local value = string.sub(matches[2], 1, 1000)
  local text = save_value(msg, name, value)
  local hash2 = "cmdset:"..msg.to.id..":"..msg.from.id
  redis:del(hash2)
  return text
end

local hash5 = "cmdgset:"..msg.to.id..":"..msg.from.id
if redis:get(hash5) == 'send gcmd' then
  local name = string.sub(matches[1], 1, 50)
  local value = string.sub(matches[2], 1, 1000)
  local text = save_gvalue(msg, name, value)
  local hash6 = "cmdgset:"..msg.to.id..":"..msg.from.id
  redis:del(hash6)
  return text
end

if matches[1] == 'del command' and permissions(msg.from.id, msg.to.id, "settings") then
   redis:set("delcmd:"..msg.to.id..":"..msg.from.id, "del cmd")
   return reply_msg(msg.id,'حالا دستوری که میخوای از ربات حذف شه رو بفرست.',ok_cb,false)
end

if matches[1] == 'del global command' and is_sudo(msg) then
   redis:set("delgcmd:"..msg.to.id..":"..msg.from.id, "del gcmd")
   return reply_msg(msg.id,'حالا دستوری که میخوای از ربات حذف شه رو بفرست.',ok_cb,false)
end

local hashdel = "delcmd:"..msg.to.id..":"..msg.from.id
 if redis:get(hashdel) == 'del cmd' then
  local name = string.sub(matches[1], 1, 50)
  local hshdel2 = "delcmd:"..msg.to.id..":"..msg.from.id
  redis:del(hshdel2)
  return del_value(msg, name)
 end
 
 local hshdel = "delgcmd:"..msg.to.id..":"..msg.from.id
 if redis:get(hshdel) == 'del gcmd' then
  local name = string.sub(matches[1], 1, 50)
  local hshdel21 = "delgcmd:"..msg.to.id..":"..msg.from.id
  redis:del(hshdel21)
  return del_gvalue(msg, name)
 end
 
if matches[1] == 'cmds' and permissions(msg.from.id, msg.to.id, "settings") then
   return group_cmds(msg)
end
if matches[1] == 'global cmds' and permissions(msg.from.id, msg.to.id, "settings") then
   return global_cmds(msg)
end
end
return {
  patterns = {
   "^[#!/](c command)$",
   "^[#!/](c global command)$",
   "^[#!/](cmds)$",
   "^[#!/](global cmds)$",
   "^[#!/](del command)$",
   "^[#!/](del global command)$",
   "^[#!/]([^%s]+) (.+)$",
   "^[#!/]([^%s]+)$",
  }, 
  run = run 
}



--[[

     **************************
     *  BlackPlus Plugins...  *
     *                        *
     *     By @MehdiHS        *
     *                        *
     *  Channel > @Black_Ch   *
     **************************
	 
]]
local day = 86400
local function is_channel_disabled( receiver )
	if not _config.disabled_channels then
		return false
	end

	if _config.disabled_channels[receiver] == nil then
		return false
	end

  return _config.disabled_channels[receiver]
end

local function enable_channel(receiver, to_id)
	if not _config.disabled_channels then
		_config.disabled_channels = {}
	end

	if _config.disabled_channels[receiver] == nil then
		return
	end
	
	_config.disabled_channels[receiver] = false
	save_config()
	return
end

local function disable_channel(receiver, to_id)
	if not _config.disabled_channels then
		_config.disabled_channels = {}
	end
	
	_config.disabled_channels[receiver] = true

	save_config()
	return
end

local function pre_process(msg)
  if is_channel_disabled(get_receiver(msg)) then
     return false
  end
if msg.text == "#add" or msg.text == "!add" or msg.text == "/add" then
if is_sudo(msg) then
redis:set("charged:"..msg.to.id,true)
enable_channel(get_receiver(msg))
local text = "ربات با موفقیت فعال شد!"
reply_msg(msg.id,text,ok_cb,false)
end
end
if msg.text == "#hid" or msg.text == "!hid" or msg.text == "/hid" and is_sudo(msg) then
return reply_msg(msg.id,msg.to.id,ok_cb,false)
end
if msg.to.type == 'channel' or msg.to.type == 'chat' then
local data = 'link:'..msg.to.id
local group_link = redis:get(data)
if not redis:get("charged:"..msg.to.id) then
if not is_channel_disabled(get_receiver(msg)) then
disable_channel(get_receiver(msg))
local sudo = 56693692
send_large_msg("user#id"..sudo,"شارژ این گروه به اتمام رسید \nName : "..msg.to.print_name:gsub("_", " ").."\nLink : "..(group_link or "تنظیم نشده").."\nID : "..msg.to.id..'\n\nدر صورتی که میخواهید ربات این گروه را ترک کند از دستور زیر استفاده کنید\n\n/leave'..msg.to.id..'\nبرای جوین دادن توی این گروه میتونی از دستور زیر استفاده کنی:\n/join91752'..msg.to.id..'\n_________________\nدر صورتی که میخواهید گروه رو دوباره شارژ کنید میتوانید از کد های زیر استفاده کنید...\n\n<code>برای شارژ 1 ماهه:</code>\n/plan1'..msg.to.id..'\n\n<code>برای شارژ 3 ماهه:</code>\n/plan2'..msg.to.id..'\n\n<code>برای شارژ نامحدود:</code>\n/plan3'..msg.to.id,ok_cb,false)
send_large_msg(get_receiver(msg),"شارژ این گروه به اتمام رسید و ربات در گروه غیر فعال شد...\nبرای تمدید کردن ربات به @MehdiHS پیام دهید.\nدر صورت ریپورت بودن میتوانید با ربات زیر با ما در ارتباط باشید:\n @BlackSupport_Bot",ok_cb,false)
send_large_msg(get_receiver(msg),"ربات به دلایلی گروه را ترک میکند\nبرای اطلاعات بیشتر میتوانید با @MehdiHS در ارتباط باشید.\nدر صورت ریپورت بودن میتوانید با ربات زیر به ما پیام دهید\n@BlackSupport_Bot\n\nChannel> @Black_Ch",ok_cb,false)
       leave_channel('channel#id'..msg.to.id, ok_cb, false)
	  https.request("https://api.telegram.org/bot229533808:AAGNWomh4OO1G13TvOqyjfQf-lHDJrBw8NU/sendMessage?chat_id=56693692&text="..URL.escape("شارژ این گروه به اتمام رسید \nName : "..msg.to.print_name:gsub("_", " ").."\nLink : "..(group_link or "تنظیم نشده").."\nID : "..msg.to.id..'\n\nدر صورتی که میخواهید ربات این گروه را ترک کند از دستور زیر استفاده کنید\n\n/leave'..msg.to.id..'\nبرای جوین دادن توی این گروه میتونی از دستور زیر استفاده کنی:\n/join91752'..msg.to.id..'\n_________________\nدر صورتی که میخواهید گروه رو دوباره شارژ کنید میتوانید از کد های زیر استفاده کنید...\n\n<code>برای شارژ 1 ماهه:</code>\n/plan1'..msg.to.id..'\n\n<code>برای شارژ 3 ماهه:</code>\n/plan2'..msg.to.id..'\n\n<code>برای شارژ نامحدود:</code>\n/plan3'..msg.to.id)..'&parse_mode=HTML')
end
end
  if is_channel_disabled(receiver) then
  	msg.text = ""
  end
 end
	return msg
end
local function run(msg, matches)
if msg.to.type == 'channel' or msg.to.type == 'chat' then
if matches[1] == "charge" and matches[2] and not matches[3] and is_sudo(msg) then
local time = matches[2] * day
redis:setex("charged:"..msg.to.id,time,true)
 reply_msg(msg.id,'ربات با موفقیت تنظیم شد\nمدت فعال بودن ربات در گروه به '..matches[2]..' روز دیگر تنظیم شد...',ok_cb,false)
 enable_channel(get_receiver(msg))
end
    if matches[1] == "charge stats" and permissions(msg.from.id, msg.to.id, "ban") and not matches[2] then
    local ex = redis:ttl("charged:"..msg.to.id)
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
       return d.." روز تا انقضا گروه باقی مانده"
       end
    end
    if matches[1] == "charge stats" and is_sudo(msg) and matches[2] then
    local ex = redis:ttl("charged:"..matches[2])
       if ex == -1 then
        return "نامحدود!"
       else
        local d = math.floor(ex / day ) + 1
       return d.." روز تا انقضا گروه باقی مانده"
       end
    end
end
	if is_sudo(msg) then
  if matches[1]:lower() == 'leave' and matches[2] then
	   reply_msg(msg.id,'ربات با موفقیت از گروه '..matches[2]..' خارج شد.',ok_cb,false)
	   send_large_msg("channel#id"..matches[2],"ربات به دلایلی گروه را ترک میکند\nبرای اطلاعات بیشتر میتوانید با @MehdiHS در ارتباط باشید.\nدر صورت ریپورت بودن میتوانید با ربات زیر به ما پیام دهید\n@BlackSupport_Bot\n\nChannel> @Black_Ch",ok_cb,false)
       leave_channel('channel#id'..matches[2], ok_cb, false)
  end
  if matches[1]:lower() == 'plan' and matches[2] == '1' and matches[3] then
       local timeplan1 = 2592000
       redis:setex("charged:"..matches[3],timeplan1,true)
	   reply_msg(msg.id,'پلن 1 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه تا 30 روز دیگر اعتبار دارد! ( 1 ماه )',ok_cb,false)
	   send_large_msg("channel#id"..matches[3],"ربات با موفقیت فعال شد و تا 30 روز دیگر اعتبار دارد!",ok_cb,false)
       enable_channel('channel#id'..matches[3])
  end
  if matches[1]:lower() == 'plan' and matches[2] == '2' and matches[3] then
       local timeplan2 = 7776000
       redis:setex("charged:"..matches[3],timeplan2,true)
	   reply_msg(msg.id,'پلن 2 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه تا 90 روز دیگر اعتبار دارد! ( 3 ماه )',ok_cb,false)
	   send_large_msg("channel#id"..matches[3],"ربات با موفقیت فعال شد و تا 90 روز دیگر اعتبار دارد! ( 3 ماه )",ok_cb,false)
       enable_channel('channel#id'..matches[3])
  end
  if matches[1]:lower() == 'plan' and matches[2] == '3' and matches[3] then
       redis:set("charged:"..matches[3],true)
	   reply_msg(msg.id,'پلن 3 با موفقیت برای گروه '..matches[3]..' فعال شد\nاین گروه به صورت نامحدود شارژ شد!',ok_cb,false)
	   send_large_msg("channel#id"..matches[3],"ربات بدون محدودیت فعال شد ! ( نامحدود )",ok_cb,false)
       enable_channel('channel#id'..matches[3])
  end
   if matches[1]:lower() == 'join' and matches[2] == '91752' and matches[3] then
	   reply_msg(msg.id,'با موفقیت تورو به گروه '..matches[3]..' اضافه کردم.',ok_cb,false)
	   send_large_msg("channel#id"..matches[3],"Admin Joined!🌚",ok_cb,false)
	   local user_id = msg.from.id
	   channel_invite_user("channel#id"..matches[3], 'user#id56693692', ok_cb, false)
  end
    if matches[1] == "charge" and matches[2] and matches[3] then
    local time = matches[3] * day
        redis:setex("charged:"..matches[2],time,true)
		local gp = matches[2]
		reply_msg(msg.id,'ربات با موفقیت تنظیم شد\nمدت فعال بودن ربات در گروه به '..matches[3]..' روز دیگر تنظیم شد...',ok_cb,false)
		send_large_msg("chat#id"..gp,"ربات توسط ادمین به مدت <code>"..matches[3].."</code> روز شارژ شد\nبرای فعال شدن ربات در گروه از دستور /check استفاده کنید...",ok_cb,false)
		send_large_msg("channel#id"..gp,"ربات توسط ادمین به مدت <code>"..matches[3].."</code> روز شارژ شد\nبرای فعال شدن ربات در گروه از دستور /check استفاده کنید...",ok_cb,false)
        enable_channel('channel#id'..matches[2])
	end
  else 
  return  reply_msg(msg.id,'<code>فقط سازنده ربات میتواند از دستورات مدیریتی گروه های دیگر استفاده کند!</code>',ok_cb,false)
  end
if matches[1] == "rem" and is_sudo(msg) then
redis:del("charged:"..msg.to.id)
return reply_msg(msg.id,"ربات غیر فعال شد.",ok_cb,false)
end
if matches[1] == 'l edit' and is_sudo(msg) then
return '<b>Locked</b>'
end
if matches[1] == 'u edit' and is_sudo(msg) then
return '<b>Unlocked</b>'
end
end


return {
patterns = {
"^[!/#]([Cc]harge stats)$",
"^[!/#]([Cc]harge stats) (%d+)$",
"^[!/#]([Cc]harge) (%d+) (%d+)$",
"^[!/#]([Cc]harge) (%d+)$",
"^[!/#]([Jj]oin)(91752)(%d+)$",
"^[!/#]([Ll]eave)(%d+)$",
"^[!/#]([Pp]lan)([123])(%d+)$",
"^[!/#]([Rr]em)$",
"^[!/#](l edit)$",
"^[!/#](u edit)$"
},
run = run,
pre_process = pre_process
}
--[[

     **************************
     *  BlackPlus Plugins...  *
     *                        *
     *     By @MehdiHS        *
     *                        *
     *  Channel > @Black_Ch   *
     **************************
	 
]]
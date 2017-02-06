
do
local day = 86400
local bot_id = 192380819 

local function reload_plugins( )
	plugins = {}
  return load_plugins()
end

local function dgt_id(name_id)
	local var = tonumber(name_id)
	if var then
		return true
	else
		return false
	end
end

local function block_by_username(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user = result.peer_id
    chat_type = cb_extra.chat_type
    user_username = result.username
	local blocklist =  'blocklist:'
          redis:sadd(blocklist, user)
	      block_user('user#id'..user, callback, false)
          send_msg('channel#id'..chat_id, '#Done\nUser #Blocked From Bot.', ok_cb, false)
end

local function block_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local chat_type = msg.to.type
	local blocklist =  'blocklist:'
        redis:sadd(blocklist, user)
	    block_user('user#id'..user, callback, false)
        reply_msg(msg.id,'#Done\nUser #Blocked From Bot.',ok_cb,false)
end

local function unblock_by_username(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user = result.peer_id
    chat_type = cb_extra.chat_type
    user_username = result.username
	local blocklist =  'blocklist:'
          redis:srem(blocklist, user)
	      unblock_user('user#id'..user, callback, false)
          send_msg('channel#id'..chat_id, '#Done\nUser #Unblocked From Bot.', ok_cb, false)
end

local function unblock_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local chat_type = msg.to.type
	local blocklist =  'blocklist:'
        redis:srem(blocklist, user)
	    unblock_user('user#id'..user, callback, false)
        reply_msg(msg.id,'#Done\nUser #Unblocked From Bot.',ok_cb,false)
end

local function get_variables_hash(msg)
    return 'chat:'..msg.to.id..':badword'
end 

local function set_rules_channel(msg, text)
  	local rules = text
  	local hash = 'channel:id:'..msg.to.id..':rules'
  	redis:set(hash, rules)
end

local function history(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, '> '..#result..' Msgs Has Been Removed. ', ok_cb, false)
  else
    send_msg(extra.chatid, '> '..#result..' Msgs Has Been Removed. ', ok_cb, false)
  end
end

local function del_rules_channel(chat_id)
  	local hash = 'channel:id:'..chat_id..':rules'
  	redis:del(hash)
end

local function index_function(user_id)
  for k,v in pairs(_config.admin_users) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

local function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

local function callback_info(cb_extra, success, result)
local title ="Info for SuperGroup: ["..result.title.."]\n\n"
local admin_num = "Admin count: "..result.admins_count.."\n"
local user_num = "User count: "..result.participants_count.."\n"
local kicked_num = "Kicked user count: "..result.kicked_count.."\n"
local channel_id = "ID: "..result.peer_id.."\n"
if result.username then
	channel_username = "Username: @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

local function check_member_super_deleted(cb_extra, success, result)
    local receiver = cb_extra.receiver
    local msg = cb_extra.msg
    local deleted = 0 
     if success == 0 then
        send_large_msg(receiver, "Error!") 
     end
   for k,v in pairs(result) do
       if not v.first_name and not v.last_name then
          deleted = deleted + 1
		  channel_kick_user('channel#id'..msg.to.id, 'user#id'..v.peer_id, ok_cb, false)
        end
    end
    reply_msg(msg.id, "<code>"..deleted.."</code> "..lang_text(msg.to.id, 'remDeleted'),ok_cb,false) 
end 

local function whoisname(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    if chat_type == 'chat' then
        send_msg('channel#id'..chat_id, '> Username : @'..(user_username or 'None')..'\n> ID : <code>('..user_id..')</code>', ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, '> Username : @'..(user_username or 'None')..' \n> ID : <code>('..user_id..')</code>', ok_cb, false)
    end
end

local function whoisid(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = cb_extra.user_id
    if cb_extra.chat_type == 'chat' then
        send_msg('channel#id'..chat_id, '> Username : @'..(result.username or 'None')..' \n> ID : <code>('..user_id..')</code>', ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id'..chat_id, '> Username : @'..(result.username or 'None')..' \n> ID : <code>('..user_id..')</code>', ok_cb, false)
    end
end

function pv(user_msg)
	local hash = 'pvban:'
	local list = redis:smembers(hash)
	local text = 'Pv [Block/Ban] List:\n\n'
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

local function unpvban_by_username(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    chat_type = cb_extra.chat_type
    local hash =  'pvban:'
    redis:srem(hash, user_id)
	local blocklist =  'blocklist:'
    redis:srem(blocklist, user_id)
	unblock_user('user#id'..user_id, callback, false)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, 'کاربر با موفقیت از لیست خارج شد.', ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, 'کاربر با موفقیت از لیست خارج شد.', ok_cb, false)
    end
end

local function unpvban_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user_id = msg.from.id
    local hash =  'pvban:'
    redis:srem(hash, user_id)
	local blocklist =  'blocklist:'
    redis:srem(blocklist, user_id)
	unblock_user('user#id'..user_id, callback, false)
    if msg.to.type == 'chat' then
        reply_msg(msg.id, 'کاربر با موفقیت از لیست خارج شد.', ok_cb,  true)
    elseif msg.to.type == 'channel' then
        reply_msg(msg.id, 'کاربر با موفقیت از لیست خارج شد.', ok_cb,  true)
    end
end

local function a(user_id)
    local hash =  'pvban:'
    local v = redis:sismember(hash, user_id)
    return v or false
end

local function get_id_who(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
	local hash =  'info'..msg.from.id
    local hashnumb = redis:get(hash)
	local hashs = 'mymsgs:'..msg.from.id..':'..msg.to.id
    local msgs = redis:get(hashs)
    local chat = msg.to.id
    local user = msg.from.id
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
	   if msg.from.username then
    reply_msg(msg.id, lang_text(chat, 'supergroup')..': <code>'..msg.to.id..'</code>\n'..lang_text(chat, 'idusername')..': <a href="https://telegram.me/'..(msg.from.username)..'">'..'@'..(msg.from.username)..'</a>\n'..lang_text(chat, 'umsg')..': <code>'..msgs..'</code>\n'..lang_text(chat, 'user')..': <code>'..msg.from.id..'</code>', ok_cb, false)    elseif msg.to.type == 'channel' then
       else
    reply_msg(msg.id, lang_text(chat, 'supergroup')..': <code>'..msg.to.id..'</code>\n'..lang_text(chat, 'umsg')..': <code>'..msgs..'</code>\n'..lang_text(chat, 'user')..': <code>'..msg.from.id..'</code>', ok_cb, false)
       end
	end
end

local function admin_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
    if is_admin(user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    end
	else
	    table.insert(_config.admin_users, {tonumber(user_id), user_name})
		print(user_id..' added to _config table')
		save_config()
	    if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'newAdmin')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'newAdmin')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    end
	end
end

local function index_gban(user_id)
  for k,v in pairs(_gbans.gbans_users) do
    if tonumber(user_id) == tonumber(v) then
      return k
    end
  end
  return false
end

local function unmute_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local name = msg.from.username
    local hash =  'muted:'..chat
    redis:srem(hash, user)
    if msg.to.type == 'chat' then
        reply_msg(msg.id, ' '..lang_text(chat, 'userUnmuted:1')..' @'..(name or 'None')..' ('..user..') '..lang_text(chat, 'userUnmuted:2'), ok_cb,  true)
    elseif msg.to.type == 'channel' then
        reply_msg(msg.id, ' '..lang_text(chat, 'userUnmuted:1')..' @'..(name or 'None')..' ('..user..') '..lang_text(chat, 'userUnmuted:2'), ok_cb,  true)
    end
end

local function gunmute_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local name = msg.from.username
    local hash =  'gmuted:'
    redis:srem(hash, user)
    if msg.to.type == 'chat' then
        reply_msg(msg.id, ' کاربر در تمامی گروه های ربات آنمیوت شد', ok_cb,  true)
    elseif msg.to.type == 'channel' then
        reply_msg(msg.id, ' کاربر در تمامی گروه های ربات آنمیوت شد', ok_cb,  true)
    end
end

local function mute_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local name = msg.from.username
	if permissions(user, chat, "link") then
           send_msg('channel#id'..chat,lang_text(chat, 'cnotmmod'), ok_cb, false)
    else
    local hash =  'muted:'..chat
    redis:sadd(hash, user)
    if msg.to.type == 'chat' then
        reply_msg(msg.id, ' '..lang_text(chat, 'userMuted:1')..' @'..(name or 'None')..' ('..user..') '..lang_text(chat, 'userMuted:2'), ok_cb,  true)
    elseif msg.to.type == 'channel' then
        reply_msg(msg.id, ' '..lang_text(chat, 'userMuted:1')..' @'..(name or 'None')..' ('..user..') '..lang_text(chat, 'userMuted:2'), ok_cb,  true)
    end
  end
end

local function gmute_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local name = msg.from.username
	if permissions(user, chat, "gban") then
           send_msg('channel#id'..chat,lang_text(chat, 'caddmt'), ok_cb, false)
    else
    local hash =  'gmuted:'
    redis:sadd(hash, user)
    if msg.to.type == 'chat' then
        reply_msg(msg.id, 'کاربر در تمامی گروه های ربات میوت شد', ok_cb,  true)
    elseif msg.to.type == 'channel' then
        reply_msg(msg.id, 'کاربر در تمامی گروه های ربات میوت شد' , ok_cb,  true)
    end
  end
end

local function mute_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
	if permissions(user_id, chat_id, "link") then
           send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotmmod'), ok_cb, false)
    else
    local hash =  'muted:'..chat_id
    redis:sadd(hash, user_id)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'userMuted:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'userMuted:2'), ok_cb,  true)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'userMuted:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'userMuted:2'), ok_cb,  true)
    end
  end
end

local function gmute_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
	if permissions(user_id, chat_id, "gban") then
           send_msg('channel#id'..chat_id,lang_text(chat_id, 'caddmt'), ok_cb, false)
    else
    local hash =  'gmuted:'
    redis:sadd(hash, user_id)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' کاربر در تمامی گروه های ربات میوت شد', ok_cb,  true)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' کاربر در تمامی گروه های ربات میوت شد', ok_cb,  true)
    end
  end
end

local function unmute_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    local hash =  'muted:'..chat_id
    redis:srem(hash, user_id)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'userMuted:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'userUnmuted:2'), ok_cb,  true)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'userMuted:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'userUnmuted:2'), ok_cb,  true)
    end
end

local function gunmute_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    local hash =  'gmuted:'
    redis:srem(hash, user_id)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, 'کاربر در تمامی گروه های ربات آنمیوت شد', ok_cb,  true)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, 'کاربر در تمامی گروه های ربات آنمیوت شد', ok_cb,  true)
    end
end

local function kick_user(user_id, chat_id)
    local chat = 'chat#id'..chat_id
    local user = 'user#id'..user_id
    local channel = 'channel#id'..chat_id
    if user_id == tostring(our_id) then
        print("I won't kick myself!")
    else
        chat_del_user(chat, user, ok_cb, true)
        channel_kick_user(channel, user, ok_cb, true)
    end
end

local function create_group(msg, group_name)
    local group_creator = msg.from.print_name
    create_group_chat(group_creator, group_name, ok_cb, false)
    return ' '..lang_text(msg.to.id, 'createGroup:1')..' "'..string.gsub(group_name, '_', ' ')..'" '..lang_text(msg.to.id, 'createGroup:2')
end

function ban_list(chat_id, user_msg)
	local hash =  'banned:'..chat_id
	local list = redis:smembers(hash)
	local text = "Banlist:\n\n"
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

function banall_list(user_msg)
	local hash =  'gban:'
	local list = redis:smembers(hash)
	local text = "Global bans:\n\n"
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

function mute_list(chat_id, user_msg)
	local hash = 'muted:'..chat_id
	local list = redis:smembers(hash)
	local text = "Muted User List:\n\n"
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

function block_list(user_msg)
	local hash = 'blocklist:'
	local list = redis:smembers(hash)
	local text = "People Who Have Been Blocked By Bot:\n\n"
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

function gmute_list(user_msg)
	local hash = 'gmuted:'
	local list = redis:smembers(hash)
	local text = "Global Mute List:\n\n"
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

local function ban_user(user_id, chat_id)
    local chat = 'chat#id'..chat_id
    if user_id == tostring(our_id) then
        print('I won\'t kick myself!')
    else
        local hash =  'banned:'..chat_id
        redis:sadd(hash, user_id)
    end
end

local function unban_user(user_id, chat_id)
    local hash =  'banned:'..chat_id
    redis:srem(hash, user_id)
end

local function is_banned(user_id, chat_id)
    local hash =  'banned:'..chat_id
    local banned = redis:sismember(hash, user_id)
    return banned or false
end

local function is_muteduser(user_id, chat_id)
    local hash =  'muted:'..chat_id
    local muted = redis:sismember(hash, user_id)
    return muted or false
end

local function is_gmuteduser(user_id)
    local hash =  'gmuted:'
    local gmuted = redis:sismember(hash, user_id)
    return gmuted or false
end

local function chat_kick(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
    local chat_type = msg.to.type
	if permissions(user, chat, "link") then
           send_msg('channel#id'..chat,lang_text(chat, 'cnotmod'), ok_cb, false)
    else
    if chat_type == 'chat' then
        chat_del_user('chat#id'..chat, 'user#id'..user, ok_cb, false)
        reply_msg(msg.id, ' '..lang_text(chat, 'kickUser:1')..' '..user..' '..lang_text(chat, 'kickUser:2'), ok_cb,  true)
    elseif chat_type == 'channel' then
        channel_kick_user('channel#id'..chat, 'user#id'..user, ok_cb, false)
        reply_msg(msg.id, ' '..lang_text(chat, 'kickUser:1')..' '..user..' '..lang_text(chat, 'kickUser:2'), ok_cb,  true)
    end
  end
end

local function chat_ban(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user = msg.from.id
	if permissions(user, chat, "link") then
           send_msg('channel#id'..chat,lang_text(chat, 'cnotmod'), ok_cb, false)
    else
    local hash =  'banned:'..chat_id
        redis:sadd(hash, user)
    chat_del_user('chat#id'..chat, 'user#id'..user, ok_cb, false)
    reply_msg(msg.id, ' '..lang_text(chat, 'banUser:1')..' '..user..' '..lang_text(chat, 'banUser:2'), ok_cb,  true)
  end
end

local function gban_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user_id = msg.from.id
	if permissions(user_id, chat, "gban") then
           send_msg('channel#id'..chat,lang_text(chat, 'cnotadmin'), ok_cb, false)
    else
    local hash =  'gban:'
    redis:sadd(hash, user_id)
	local blocklist =  'blocklist:'
    redis:sadd(blocklist, user_id)
	 block_user('user#id'..user_id, callback, false)
    if msg.to.type == 'chat' then
        chat_del_user('chat#id'..chat, 'user#id'..user_id, ok_cb, false)
        reply_msg(msg.id, ' '..lang_text(chat, 'gbanUser:1')..' '..user_id..' '..lang_text(chat, 'gbanUser:2'), ok_cb,  true)
    elseif msg.to.type == 'channel' then
        channel_kick_user('channel#id'..chat, 'user#id'..user_id, ok_cb, false)
        reply_msg(msg.id, ' '..lang_text(chat, 'gbanUser:1')..' '..user_id..' '..lang_text(chat, 'gbanUser:2'), ok_cb,  true)
    end
  end
 end

local function ungban_by_reply(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat = msg.to.id
    local user_id = msg.from.id
    local hash =  'gban:'
    redis:srem(hash, user_id)
	local blocklist =  'blocklist:'
    redis:srem(blocklist, user_id)
	unblock_user('user#id'..user_id, callback, false)
    if msg.to.type == 'chat' then
        reply_msg(msg.id, ' '..lang_text(chat, 'ungbanUser:1')..' '..user_id..' '..lang_text(chat, 'ungbanUser:2'), ok_cb,  true)
    elseif msg.to.type == 'channel' then
        reply_msg(msg.id, ' '..lang_text(chat, 'ungbanUser:1')..' '..user_id..' '..lang_text(chat, 'ungbanUser:2'), ok_cb,  true)
    end
end

local function channel_ban(extra, success, result)
    local msg = result
    msg = backward_msg_format(msg)
    local chat = msg.to.id
    local user = msg.from.id
	if permissions(user, chat, "link") then
            send_msg('channel#id'..chat,lang_text(chat, 'cnotmod'), ok_cb, false)
    else
    channel_kick_user('channel#id'..chat, 'user#id'..user, ok_cb, true)
    reply_msg(msg.id, ' '..lang_text(chat, 'banUser:1')..' '..user..' '..lang_text(chat, 'banUser:2'), ok_cb,  true)
    ban_user(user, chat)
  end
end

local function chat_unban(extra, success, result)
    result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    unban_user(user_id, chat_id)
    reply_msg(msg.id, lang_text(chat_id, 'unbanUser:1')..' '..user_id..' '..lang_text(chat_id, 'unbanUser:2'), ok_cb,  true)
end

local function channel_unban(extra, success, result)
    local msg = result
    local msg = backward_msg_format(msg)
    local chat_id = msg.to.id
    local user_id = msg.from.id
    unban_user(user_id, chat_id)
    reply_msg(msg.id, lang_text(chat_id, 'unbanUser:1')..' '..user_id..' '..lang_text(chat_id, 'unbanUser:2'), ok_cb,  true)
    
end

local function ban_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
	if permissions(user_id, chat_id, "link") then
           send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotmod'), ok_cb, false)
    else
    local hash =  'banned:'..chat_id
     redis:sadd(hash, user_id)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'banUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'banUser:2'), ok_cb, false)
        chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'banUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'banUser:2'), ok_cb, false)
        channel_kick_user('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    end
    ban_user(user_id, chat_id)
   end
end

local function kick_by_username(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    chat_type = cb_extra.chat_type
    user_username = result.username
	if permissions(user_id, chat_id, "link") then
          send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotmod'), ok_cb, false)
    else
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'kickUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'kickUser:2'), ok_cb, false)
        chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'kickUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'kickUser:2'), ok_cb, false)
        channel_kick_user('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    end
   end
end

local function gban_by_username(cb_extra, success, result)
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_username = result.username
    local chat_type = cb_extra.chat_type 
	if permissions(user_id, chat_id, "gban") then
          send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotadmin'), ok_cb, false)
    else
    local hash =  'gban:'
    redis:sadd(hash, user_id)
	local blocklist =  'blocklist:'
    redis:sadd(blocklist, user_id)
	block_user('user#id'..user_id, callback, false)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'gbanUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'gbanUser:2'), ok_cb, false)
        chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'gbanUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'gbanUser:2'), ok_cb, false)
        channel_kick_user('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
      end
   end
end

local function ungban_by_username(cb_extra, success, result)
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    chat_type = cb_extra.chat_type
    local indexid = index_gban(user_id)
    local hash =  'gban:'
    redis:srem(hash, user_id)
	local blocklist =  'blocklist:'
    redis:srem(blocklist, user_id)
	unblock_user('user#id'..user_id, callback, false)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'ungbanUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'ungbanUser:2'), ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'ungbanUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'ungbanUser:2'), ok_cb, false)
    end
end

local function unban_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    local hash =  'banned:'..chat_id
    redis:srem(hash, user_id)
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'unbanUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'unbanUser:2'), ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'unbanUser:1')..' @'..(user_username or 'None')..' ('..user_id..') '..lang_text(chat_id, 'unbanUser:2'), ok_cb, false)
    end
end

local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." For "..chat_name..":\n\n"
for k,v in pairsByKeys(result) do
if not v.username then
	name = " "
else
	vname = v.username
	name = vname
	end
		text = text.."\n"..i.." - @"..name.." ["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

local function is_gbanned(user_id)
    local hash =  'gban:'
    local banned = redis:sismember(hash, user_id)
    return banned or false
end

local function mod_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
    local hash = 'mod:'..chat_id
    if redis:sismember(hash, user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    end
	else
	    redis:sadd(hash, user_id)
	    if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'newMod')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'newMod')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    end
	end
end

local function owner_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
    local hash = 'gpowner:'..chat_id
    if redis:sismember(hash, user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    end
	else
	    redis:sadd(hash, user_id)
	    if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'newOwner')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'newOwner')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    end
	end
end

local function guest_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
	local nameid = index_function(user_id)
	local hash = 'mod:'..chat_id
    if redis:sismember(hash, user_id) then
       redis:srem(hash, user_id)
    end
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, '@'..(user_name or 'None')..' ('..user_id..') '..lang_text(chat_id, 'nowUser'), ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, '@'..(user_name or 'None')..' ('..user_id..') '..lang_text(chat_id, 'nowUser'), ok_cb, false)
    end
end

local function rmvadmin_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
	local nameid = index_function(user_id)
	if is_admin(user_id) then
		table.remove(_config.admin_users, nameid)
		print(user_id..' added to _config table')
		save_config()
	end
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, '@'..(user_name or 'None')..' ('..user_id..') '..lang_text(chat_id, 'rmvadmin'), ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, '@'..(user_name or 'None')..' ('..user_id..') '..lang_text(chat_id, 'rmvadmin'), ok_cb, false)
    end
end

local function demowner_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
	local nameid = index_function(user_id)
	local hash = 'gpowner:'..chat_id
    if redis:sismember(hash, user_id) then
       redis:srem(hash, user_id)
    end
    if chat_type == 'chat' then
        send_msg('chat#id'..chat_id, '@'..(user_name or 'None')..' ('..user_id..') '..lang_text(chat_id, 'demOwner'), ok_cb, false)
    elseif chat_type == 'channel' then
        send_msg('channel#id'..chat_id, '@'..(user_name or 'None')..' ('..user_id..') '..lang_text(chat_id, 'demOwner'), ok_cb, false)
    end
end

local function set_admin(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
	if is_admin(tonumber(user_id)) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'alreadyAdmin'), ok_cb, false)
	    end
	else
    	table.insert(_config.admin_users, {tonumber(user_id), user_name})
		print(user_id..' added to _config table')
		save_config()
	    if cb_extra.chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'newAdmin')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'newAdmin')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    end
	end
end

local function set_mod(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
    local hash = 'mod:'..chat_id
	if redis:sismember(hash, user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'alreadyMod'), ok_cb, false)
	    end
	else
       redis:sadd(hash, user_id)
	    if cb_extra.chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'newMod')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'newMod')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    end
	end
end

local function set_owner(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
    local hash = 'gpowner:'..chat_id
	if redis:sismember(hash, user_id) then
    	if chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'alreadyOwner'), ok_cb, false)
	    end
	else
    	redis:sadd(hash, user_id)
	    if cb_extra.chat_type == 'chat' then
	        send_msg('chat#id'..chat_id, ' '..lang_text(chat_id, 'newOwner')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_msg('channel#id'..chat_id, ' '..lang_text(chat_id, 'newOwner')..' @'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
	    end
	end
end

local function set_guest(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
    local nameid = index_function(tonumber(user_id))
    local hash = 'mod:'..chat_id
    if redis:sismember(hash, user_id) then
       redis:srem(hash, user_id)
    end
    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id'..chat_id, lang_text(chat_id, 'nowUser')..'@'..(user_name or 'None')..' ('..user_id..') ', ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id'..chat_id, lang_text(chat_id, 'nowUser')..'@'..(user_name or 'None')..' ('..user_id..') ', ok_cb, false)
    end
end

local function rmv_admin(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
    local nameid = index_function(tonumber(user_id))
    if is_admin(user_id) then
		table.remove(_config.admin_users, nameid)
		print(user_id..' added to _config table')
		save_config()
	end
    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id'..chat_id, lang_text(chat_id, 'rmvadmin')..'@'..(user_name or 'None')..' ('..user_id..') ', ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id'..chat_id, lang_text(chat_id, 'rmvadmin')..'@'..(user_name or 'None')..' ('..user_id..') ', ok_cb, false)
    end
end

local function dem_owner(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
    local nameid = index_function(tonumber(user_id))
    local hash = 'gpowner:'..chat_id
    if redis:sismember(hash, user_id) then
       redis:srem(hash, user_id)
    end
	    if cb_extra.chat_type == 'chat' then
        send_msg('chat#id'..chat_id, lang_text(chat_id, 'demOwner')..'@'..(user_name or 'None')..' ('..user_id..') ', ok_cb, false)
    elseif cb_extra.chat_type == 'channel' then
        send_msg('channel#id'..chat_id, lang_text(chat_id, 'demOwner')..'@'..(user_name or 'None')..' ('..user_id..')', ok_cb, false)
    end
end

local function admin_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_admin, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function mod_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_mod, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function owner_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function guest_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_guest, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function rmvadmin_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, rmv_admin, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function demowner_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, dem_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function members_chat(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
	local text = ""
	for k,v in pairs(result.members) do
		if v.username then
			text = text..'@'..v.username..' '
		end
	end
	return send_large_msg('chat#id'..chat_id, text, ok_cb, true)
end

local function members_channel(extra, success, result)
	local chat_id = extra.chat_id
	local text = ""
	for k,user in ipairs(result) do
		if user.username then
			text = text..'@'..user.username..' '
		end
	end
	return send_large_msg('channel#id'..chat_id, text, ok_cb, true)
end

local function members_chat_msg(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
	local text = ' '
	for k,v in pairs(result.members) do
		if v.username then
			text = text..'@'..v.username..' '
		end
	end
	text = text..'\n\n'..extra.text_msg
	return send_large_msg('chat#id'..chat_id, text, ok_cb, true)
end

local function members_channel_msg(extra, success, result)
	local chat_id = extra.chat_id
	local text = ' '
	for k,user in ipairs(result) do
		if user.username then
			text = text..'@'..user.username..' '
		end
	end
	text = text..'\n\n'..extra.text_msg
	return send_large_msg('channel#id'..chat_id, text, ok_cb, true)
end

function modlist(chat_id, user_msg)
	local hash =  'mod:'..chat_id
	local list = redis:smembers(hash)
	local text = "Modlist:\n\n"
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

function ownerlist(chat_id, user_msg)
	local hash =  'gpowner:'..chat_id
	local list = redis:smembers(hash)
	local text = "Ownerlist:\n\n"
	for k,v in pairs(list) do
	local user_info = redis:hgetall('user:'..v)
		if user_info and user_info.username then
			local username = user_info.username
			text = text..k.." - @"..username.." ["..v.."]\n"
		else
			text = text..k.." - "..v.."\n"
		end
	end
	return reply_msg(user_msg,text,ok_cb,false)
end

local function init_def_rules(chat_id)
  	local rules = '|BlackPlus V7|\n'
              ..'Developed By @MehdiHS\n'
              ..'Channel > @Black_CH\n'
              ..'Website > BlackPlus.ir\n'
              ..'Support Team > @BlackSupport_Bot\n'
              ..'Set Group Rules Via /setrules Command!'
              
  	local hash='channel:id:'..chat_id..':rules'
  	redis:set(hash, rules)
end

local function ret_rules_channel(msg)
  	local chat_id = msg.to.id
  	local hash = 'channel:id:'..msg.to.id..':rules'
  	if redis:get(hash) then
  		return reply_msg(msg.id,redis:get(hash), ok_cb, false)
  	else
  		init_def_rules(chat_id)
  		return reply_msg(msg.id,redis:get(hash), ok_cb, false)
  	end
end

local function inv_by_reply(extra, success, result)
    local msg = result
    msg = backward_msg_format(msg)
    local chat = msg.to.id
    local user = msg.from.id
    channel_invite_user("channel#id"..chat, 'user#id'..user, ok_cb, false)
end

local function inv_by_username(cb_extra, success, result)
    chat_type = cb_extra.chat_type
    chat_id = cb_extra.chat_id
    user_id = result.peer_id
    user_username = result.username
    channel_invite_user("channel#id"..chat_id, 'user#id'..user_id, ok_cb, false)
end

local function remove_message(extra, success, result)
    msg = backward_msg_format(result)
    delete_msg(msg.id, ok_cb, false)
end

local function set_group_photo(msg, success, result)
    local receiver = get_receiver(msg)
    if success then
        local file = 'source/dl/_'..msg.to.id..'.jpg'
        print('File downloaded to:', result)
        os.rename(result, file)
        print('File moved to:', file)
        if msg.to.type == 'channel' then
        	channel_set_photo (receiver, file, ok_cb, false)
	elseif msg.to.type == 'chat' then
		chat_set_photo(receiver, file, ok_cb, false)
	end
         reply_msg(msg.id,' '..lang_text(msg.to.id, 'photoSaved'), ok_cb, true)
    else
        print('Error downloading: '..msg.id)
         reply_msg(msg.id,' '..lang_text(msg.to.id, 'photoSaved'), ok_cb, true)
    end
end

local function pre_process(msg)
    local svuser = 'user:'..msg.from.id
	if msg.from.username then
      redis:hset(svuser, 'username', msg.from.username)
    end
  if msg.to.type == 'user' then
    local max = 5
    local t = 3
    local hashses = 'pvflod:'..msg.from.id
        if not redis:get(hashses) then
            local aaa = 'pvspam:'..msg.from.id
            local mg = tonumber(redis:get(aaa) or 0)
        if mg > max then
            local receiver = get_receiver(msg)
            local user = msg.from.id
			local user_id = msg.from.id
			local v = a(user_id)
         if v then
			return
		else
			local mehdi = 56693692
					user_id = msg.from.id
                    reply_msg(msg.id, 'شما به دلیل ارسال اسپم به ربات از ربات بلاک و گلوبال بن میشوید...\nگزارش این اتفاق با موفقیت برای ادمین ارسال شد\nبزودی به این مشکل رسیدگی میکنیم!', ok_cb, true)
					block_user('user#id'..user_id, callback, false)
					send_large_msg('user#id'..mehdi, 'کاربری به دلیل ارسال اسپم به پیوی ربات , بلاک و گلوبال بن شد.\nاطلاعات کاربر:\n\nنام: '..msg.from.print_name..'\nیوزرنیم: @'..msg.from.username..'\nایدی: '..msg.from.id, ok_cb, true)
			local blocklist =  'blocklist:'
			local bhash = 'pvban:'
					redis:sadd(blocklist, user_id)
                    redis:sadd(bhash, user_id)
		 end
        end
                    redis:setex(aaa, t, mg+1)
      end
	end
if not msg.service then
    if msg.media then
    if msg.media.caption == 'sticker.webp' then
    local hash = 'mymsgs:'..msg.from.id..':'..msg.to.id
    redis:incr(hash)
	local hashgp = 'gpmsgs:'..msg.to.id
    redis:incr(hashgp)
    elseif msg.media.type == 'photo' then
    local hash = 'mymsgs:'..msg.from.id..':'..msg.to.id
    redis:incr(hash)
    local hashgp = 'gpmsgs:'..msg.to.id
    redis:incr(hashgp)
    end
    else
    if msg.text then
    local hash = 'mymsgs:'..msg.from.id..':'..msg.to.id
    redis:incr(hash)
	local hashgp = 'gpmsgs:'..msg.to.id
    redis:incr(hashgp)
    else
    local hash = 'mymsgs:'..msg.from.id..':'..msg.to.id
    redis:incr(hash)
	local hashgp = 'gpmsgs:'..msg.to.id
    redis:incr(hashgp)
    end
	end
	if msg.media then
    if msg.media.caption == 'sticker.webp' then
    local hash = 'cmdusers:'
    redis:incr(hash)
    elseif msg.media.type == 'photo' then
    local hash = 'cmdusers:'
    redis:incr(hash)
    end
    else
    if msg.text then
    local hash = 'cmdusers:'
    redis:incr(hash)
    else
    local hash = 'cmdusers:'
    redis:incr(hash)
    end
	end
end
    local hash = 'flood:max:'..msg.to.id
    if not redis:get(hash) then
        floodMax = 5
    else
        floodMax = tonumber(redis:get(hash))
    end

    local hash = 'flood:time:'..msg.to.id
    if not redis:get(hash) then
        floodTime = 3
    else
        floodTime = tonumber(redis:get(hash))
    end
    if not permissions(msg.from.id, msg.to.id, "pre_process") then
        local hashse = 'anti-flood:'..msg.to.id
        if not redis:get(hashse) then
            if msg.from.type == 'user' then
                if not permissions(msg.from.id, msg.to.id, "no_flood_ban") then
                    local hash = 'flood:'..msg.from.id..':'..msg.to.id..':msg-num'
                    local msgs = tonumber(redis:get(hash) or 0)
                    if msgs > floodMax then
                        local receiver = get_receiver(msg)
                        local user = msg.from.id
                        local chat = msg.to.id
                        local channel = msg.to.id
						 local user_id = msg.from.id
						 local banned = is_banned(user_id, msg.to.id)
                         if banned then
						 return
						 else
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, lang_text(chat, 'user')..' @'..msg.from.username..' ('..msg.from.id..') '..lang_text(chat, 'isFlooding'), ok_cb, true)
                            chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, lang_text(chat, 'user')..' @'..msg.from.username..' ('..msg.from.id..') '..lang_text(chat, 'isFlooding'), ok_cb, true)
                            channel_kick_user('channel#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
                        end
						user_id = msg.from.id
						local bhash =  'banned:'..msg.to.id
                        redis:sadd(bhash, user_id)
					  end
                    end
                    redis:setex(hash, floodTime, msgs+1)
                end
            end
        end
		if msg.text then -- msg.text checks
 	if msg.to.type == 'user' then
      reply_msg(msg.id,'<b>سلام</b>\n\n<b>برای استفاده از این ربات باید با تیم پشتیبانی هماهنگی داشته باشید و در واقع برای هر گروهی که با این ربات میخواهید باید هزینه ای بپردازید.</b>\n\n<i>قیمت های خرید گروه با این ربات را میتوانید با رفتن به ربات پشتیبانی ما دریافت کنید.</i>\n<code>ایدی ربات :</code> @BlackSupport_Bot\n\n\n<b>برای ارتباط با ما میتوانید از طریق 2 آیدی زیر استفاده کنید...</b>\n@MehdiHS\n<b>کسایی که ریپورت هستند میتوانند پیامشون رو در ربات زیر بفرستند و از ظریق اون با ما در ارتباط باشند... </b>\n@BlackSupport_Bot \n\n<code>در کانال ما عضو شوید:</code>\n@Black_Ch\n\n\n\n<b>قیمت های فعلی برای خرید گروه 👇👇👇👇</b>',ok_cb,false)
	  reply_msg(msg.id, '<b>لیست قیمت های خرید گروه با</b> <a href="https://telegram.me/bIackplus">BlackPlus</a>\n\n<i> - 1 ماهه > 5000 تومان</i>\n<i> - 3 ماهه > 10000 تومان</i>\n<i> - نامحدود > 20000 تومان</i>',ok_cb,false)
	end
	local char_hash = 'spam:'..msg.to.id
   if redis:get(char_hash) then
	        local char = msg.text
	        local numbhash = 'maxchar:'..msg.to.id
	if not redis:get(numbhash) then
                numb = 4096
    else
                numb = tonumber(redis:get(numbhash))
	    if string.len(char) > numb then
		delete_msg(msg.id, ok_cb, false)
		    local chat = msg.to.id 
			local hashtaa = 'checkspam:'..msg.from.id
			if not redis:get(hashtaa) then
           send_msg(get_receiver(msg), lang_text(msg.to.id, 'longmsg')..' '..numb..' '..lang_text(msg.to.id, 'longmsg2')..'\n\n'..lang_text(msg.to.id, 'longmsg3')..': @'..msg.from.username..' ('..msg.from.id..')', ok_cb, false) 
           local hashta = 'checkspam:'..msg.from.id
		   redis:setex(hashta, tonumber(20), true)
		   else 
		   return
		end
	  end
	end
   end
		local is_link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]")
			link_hash = 'links:'..msg.to.id
			if is_link_msg and redis:get(link_hash) then
				delete_msg(msg.id, ok_cb, false)
		end
		local is_tag_msg = msg.text:match("@")
			tag_hash = 'tag:'..msg.to.id
			if is_tag_msg and redis:get(tag_hash) then
				delete_msg(msg.id, ok_cb, false)
		end
		local is_hashtag_msg = msg.text:match("#")
			hashtag_hash = 'hashtag:'..msg.to.id
			if is_hashtag_msg and redis:get(hashtag_hash) then
				delete_msg(msg.id, ok_cb, false)
		end
		local is_webpage_msg = msg.text:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.text:match("[Hh][Tt][Tt][Pp]://") or msg.text:match(".[Ii][Rr]") or msg.text:match(".[Cc][Oo][Mm]") or msg.text:match(".[Oo][Rr][Gg]") or msg.text:match(".[Ii][Nn][Ff][Oo]") or msg.text:match("[Ww][Ww][Ww].") or msg.text:match(".[Tt][Kk]")
			weblink_hash = 'webpage:'..msg.to.id
			if is_webpage_msg and redis:get(weblink_hash) then
				delete_msg(msg.id, ok_cb, false)
		end
		local is_badw_msg = msg.text:match("[Kk][Ii][Rr]") or msg.text:match("[Kk][Oo][Ss]") or msg.text:match("[Kk][Oo][Ss][Dd][Ee]") or msg.text:match("[Kk][Oo][Oo][Nn][Ii]") or msg.text:match("[Jj][Ee][Nn][Dd][Ee]") or msg.text:match("[Jj][Ee][Nn][Dd][Ee][Hh]") or msg.text:match("[Kk][Oo][Oo][Nn]") or msg.text:match("کیر") or msg.text:match("کسکش") or msg.text:match("کونی") or msg.text:match("جنده") or msg.text:match("حشری")
			badw_hash = 'badword:'..msg.to.id
			if is_badw_msg and redis:get(badw_hash) then
				delete_msg(msg.id, ok_cb, false)
		end
		local is_emoji_msg = msg.text:match("[😀😬😁😂😃😄😅☺️🙃🙂😊😉😇😆😋😌😍😘😗😙😚🤗😎🤓🤑😛😝😜😏😶😐😑😒🙄🤔😕😔😡😠😟😞😳🙁☹️😣😖😫😩😤😧😦😯😰😨😱😮😢😥😪😓😭😵😲💩💤😴🤕🤒😷🤐😈👿👹👺💀👻👽😽😼😻😹😸😺🤖🙀😿😾🙌🏻👏🏻👋🏻👍🏻👎🏻👊🏻✊🏻✌🏻👌🏻✋🏻👐🏻💪🏻🙏🏻☝🏻️👆🏻👇🏻👈🏻👉🏻🖕🏻🖐🏻🤘🏻🖖🏻✍🏻💅🏻👄👅👂🏻👃🏻👁👀👤👥👱🏻👩🏻👨🏻👧🏻👦🏻👶🏻🗣👴🏻👵🏻👲🏻🏃🏻🚶🏻💑👩‍❤️‍👩👨‍❤️‍👨💏👩‍❤️‍💋‍👩👨‍❤️‍💋‍👨👪👩‍👩‍👧‍👦👩‍👩‍👧👩‍👩‍👦👨‍👩‍👧‍👧👨‍👩‍👦‍👦👨‍👩‍👧‍👦👨‍👩‍👧👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👘👙👗👔👖👕👚💄💋👣👠👡👢👞🎒⛑👑🎓🎩👒👟👝👛👜💼👓🕶💍🌂🐶🐱🐭🐹🐰🐻🐼🐸🐽🐷🐮🦁🐯🐨🐙🐵🙈🙉🙊🐒🐔🐗🐺🐥🐣🐤🐦🐧🐴🦄🐝🐛🐌🐞🐜🕷🦂🦀🐍🐢🐠🐟🐅🐆🐊🐋🐬🐡🐃🐂🐄🐪🐫🐘🐐🐓🐁🐀🐖🐎🐑🐏🦃🕊🐕]")
			emoji_hash = 'emoji:'..msg.to.id
			if is_emoji_msg and redis:get(emoji_hash) then
				delete_msg(msg.id, ok_cb, false)
		end
		local is_eng_msg = msg.text:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]")
			eng_hash = 'english:'..msg.to.id
			if is_eng_msg and redis:get(eng_hash) then
				delete_msg(msg.id, ok_cb, false)
		end
		if msg.service then 
		    tg_hash = 'tgservices:'..msg.to.id
			if redis:get(tg_hash) then
				delete_msg(msg.id, ok_cb, false)
			end
		end
			local is_squig_msg = msg.text:match("[\216-\219][\128-\191]")
			ar_hash = 'arabic:'..msg.to.id
			if is_squig_msg and redis:get(ar_hash) then
				delete_msg(msg.id, ok_cb, false)
			end
		end
		if msg.fwd_from then
			if msg.fwd_from.title then
			local is_link_title = msg.fwd_from.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.fwd_from.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]")
				link_hash = 'links:'..msg.to.id
				if is_link_title and redis:get(link_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			local is_tag_title = msg.fwd_from.title:match("@")
				tag_hash = 'tag:'..msg.to.id
				if is_tag_title and redis:get(tag_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			local is_hashtag_title = msg.fwd_from.title:match("#")
				hashtag_hash = 'hashtag:'..msg.to.id
				if is_hashtag_title and redis:get(hashtag_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			local is_webpage_title = msg.fwd_from.title:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.fwd_from.title:match("[Hh][Tt][Tt][Pp]://") or msg.fwd_from.title:match(".[Ii][Rr]") or msg.fwd_from.title:match(".[Cc][Oo][Mm]") or msg.fwd_from.title:match(".[Oo][Rr][Gg]") or msg.fwd_from.title:match(".[Ii][Nn][Ff][Oo]") or msg.fwd_from.title:match("[Ww][Ww][Ww].") or msg.fwd_from.title:match(".[Tt][Kk]")
				wp_hash = 'webpage:'..msg.to.id
				if is_webpage_title and redis:get(wp_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			local is_badw_title = msg.fwd_from.title:match("[Kk][Ii][Rr]") or msg.fwd_from.title:match("[Kk][Oo][Ss]") or msg.fwd_from.title:match("[Kk][Oo][Ss][Dd][Ee]") or msg.fwd_from.title:match("[Kk][Oo][Oo][Nn][Ii]") or msg.fwd_from.title:match("[Jj][Ee][Nn][Dd][Ee]") or msg.fwd_from.title:match("[Jj][Ee][Nn][Dd][Ee][Hh]") or msg.fwd_from.title:match("[Kk][Oo][Oo][Nn]") or msg.fwd_from.title:match("کیر") or msg.fwd_from.title:match("کسکش") or msg.fwd_from.title:match("کونی") or msg.fwd_from.title:match("جنده") or msg.fwd_from.title:match("حشری")
				badw_hash = 'badword:'..msg.to.id
				if is_badw_title and redis:get(badw_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			local is_emoji_title = msg.fwd_from.title:match("[😀😬😁😂😃😄😅☺️🙃🙂😊😉😇😆😋😌😍😘😗😙😚🤗😎🤓🤑😛😝😜😏😶😐😑😒🙄🤔😕😔😡😠😟😞😳🙁☹️😣😖😫😩😤😧😦😯😰😨😱😮😢😥😪😓😭😵😲💩💤😴🤕🤒😷🤐😈👿👹👺💀👻👽😽😼😻😹😸😺🤖🙀😿😾🙌🏻👏🏻👋🏻👍🏻👎🏻👊🏻✊🏻✌🏻👌🏻✋🏻👐🏻💪🏻🙏🏻☝🏻️👆🏻👇🏻👈🏻👉🏻🖕🏻🖐🏻🤘🏻🖖🏻✍🏻💅🏻👄👅👂🏻👃🏻👁👀👤👥👱🏻👩🏻👨🏻👧🏻👦🏻👶🏻🗣👴🏻👵🏻👲🏻🏃🏻🚶🏻💑👩‍❤️‍👩👨‍❤️‍👨💏👩‍❤️‍💋‍👩👨‍❤️‍💋‍👨👪👩‍👩‍👧‍👦👩‍👩‍👧👩‍👩‍👦👨‍👩‍👧‍👧👨‍👩‍👦‍👦👨‍👩‍👧‍👦👨‍👩‍👧👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👘👙👗👔👖👕👚💄💋👣👠👡👢👞🎒⛑👑🎓🎩👒👟👝👛👜💼👓🕶💍🌂🐶🐱🐭🐹🐰🐻🐼🐸🐽🐷🐮🦁🐯🐨🐙🐵🙈🙉🙊🐒🐔🐗🐺🐥🐣🐤🐦🐧🐴🦄🐝🐛🐌🐞🐜🕷🦂🦀🐍🐢🐠🐟🐅🐆🐊🐋🐬🐡🐃🐂🐄🐪🐫🐘🐐🐓🐁🐀🐖🐎🐑🐏🦃🕊🐕]")
				emoji_hash = 'emoji:'..msg.to.id
				if is_emoji_title and redis:get(emoji_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			local is_eng_title = msg.fwd_from.title:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]")
				eng_hash = 'english:'..msg.to.id
				if is_eng_title and redis:get(eng_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			local is_squig_title = msg.fwd_from.title:match("[\216-\219][\128-\191]")
				ar_hash = 'arabic:'..msg.to.id
				if is_squig_title and redis:get(ar_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			end
		end
		if msg.media then
		   if msg.media.title then
	    local is_link_title = msg.media.title:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.media.title:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]")
				link_hash = 'links:'..msg.to.id
				if is_link_title and redis:get(link_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
		local is_tag_title = msg.media.title:match("@")
				tag_hash = 'tag:'..msg.to.id
				if is_tag_title and redis:get(tag_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
		local is_hashtag_title = msg.media.title:match("#")
				hashtag_hash = 'hashtag:'..msg.to.id
				if is_hashtag_title and redis:get(hashtag_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
		local is_webpage_title = msg.media.title:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.media.title:match("[Hh][Tt][Tt][Pp]://") or msg.media.title:match(".[Ii][Rr]") or msg.media.title:match(".[Cc][Oo][Mm]") or msg.media.title:match(".[Oo][Rr][Gg]") or msg.media.title:match(".[Ii][Nn][Ff][Oo]") or msg.media.title:match("[Ww][Ww][Ww].") or msg.media.title:match(".[Tt][Kk]")
				wp_hash = 'webpage:'..msg.to.id
				if is_webpage_title and redis:get(wp_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
		local is_badw_title = msg.media.title:match("[Kk][Ii][Rr]") or msg.media.title:match("[Kk][Oo][Ss]") or msg.media.title:match("[Kk][Oo][Ss][Dd][Ee]") or msg.media.title:match("[Kk][Oo][Oo][Nn][Ii]") or msg.media.title:match("[Jj][Ee][Nn][Dd][Ee]") or msg.media.title:match("[Jj][Ee][Nn][Dd][Ee][Hh]") or msg.media.title:match("[Kk][Oo][Oo][Nn]") or msg.media.title:match("کیر") or msg.media.title:match("کسکش") or msg.media.title:match("کونی") or msg.media.title:match("جنده") or msg.media.title:match("حشری")
				badw_hash = 'badword:'..msg.to.id
				if is_badw_title and redis:get(badw_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
		local is_emoji_title = msg.media.title:match("[😀😬😁😂😃😄😅☺️🙃🙂😊😉😇😆😋😌😍😘😗😙😚🤗😎🤓🤑😛😝😜😏😶😐😑😒🙄🤔😕😔😡😠😟😞😳🙁☹️😣😖😫😩😤😧😦😯😰😨😱😮😢😥😪😓😭😵😲💩💤😴🤕🤒😷🤐😈👿👹👺💀👻👽😽😼😻😹😸😺🤖🙀😿😾🙌🏻👏🏻👋🏻👍🏻👎🏻👊🏻✊🏻✌🏻👌🏻✋🏻👐🏻💪🏻🙏🏻☝🏻️👆🏻👇🏻👈🏻👉🏻🖕🏻🖐🏻🤘🏻🖖🏻✍🏻💅🏻👄👅👂🏻👃🏻👁👀👤👥👱🏻👩🏻👨🏻👧🏻👦🏻👶🏻🗣👴🏻👵🏻👲🏻🏃🏻🚶🏻💑👩‍❤️‍👩👨‍❤️‍👨💏👩‍❤️‍💋‍👩👨‍❤️‍💋‍👨👪👩‍👩‍👧‍👦👩‍👩‍👧👩‍👩‍👦👨‍👩‍👧‍👧👨‍👩‍👦‍👦👨‍👩‍👧‍👦👨‍👩‍👧👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👘👙👗👔👖👕👚💄💋👣👠👡👢👞🎒⛑👑🎓🎩👒👟👝👛👜💼👓🕶💍🌂🐶🐱🐭🐹🐰🐻🐼🐸🐽🐷🐮🦁🐯🐨🐙🐵🙈🙉🙊🐒🐔🐗🐺🐥🐣🐤🐦🐧🐴🦄🐝🐛🐌🐞🐜🕷🦂🦀🐍🐢🐠🐟🐅🐆🐊🐋🐬🐡🐃🐂🐄🐪🐫🐘🐐🐓🐁🐀🐖🐎🐑🐏🦃🕊🐕]")
				emoji_hash = 'emoji:'..msg.to.id
				if is_emoji_title and redis:get(emoji_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
		local is_eng_title = msg.media.title:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]")
				eng_hash = 'english:'..msg.to.id
				if is_eng_title and redis:get(eng_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
		local is_squig_title = msg.media.title:match("[\216-\219][\128-\191]")
				if is_squig_title and redis:get(ar_hash) then
					delete_msg(msg.id, ok_cb, false)
		end
                end
			if msg.media.description then
			local is_link_desc = msg.media.description:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.media.description:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]")
				link_hash = 'links:'..msg.to.id
				if is_link_desc and redis:get(link_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_tag_desc = msg.media.description:match("@")
				tag_hash = 'tag:'..msg.to.id
				if is_tag_desc and redis:get(tag_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_hashtag_desc = msg.media.description:match("#")
				hashtag_hash = 'hashtag:'..msg.to.id
				if is_hashtag_desc and redis:get(hashtag_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_webpage_desc = msg.media.description:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.media.description:match("[Hh][Tt][Tt][Pp]://") or msg.media.description:match(".[Ii][Rr]") or msg.media.description:match(".[Cc][Oo][Mm]") or msg.media.description:match(".[Oo][Rr][Gg]") or msg.media.description:match(".[Ii][Nn][Ff][Oo]") or msg.media.description:match("[Ww][Ww][Ww].") or msg.media.description:match(".[Tt][Kk]")
				weblink_hash = 'webpage:'..msg.to.id
				if is_webpage_desc and redis:get(weblink_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_badw_desc = msg.media.description:match("[Kk][Ii][Rr]") or msg.media.description:match("[Kk][Oo][Ss]") or msg.media.description:match("[Kk][Oo][Ss][Dd][Ee]") or msg.media.description:match("[Kk][Oo][Oo][Nn][Ii]") or msg.media.description:match("[Jj][Ee][Nn][Dd][Ee]") or msg.media.description:match("[Jj][Ee][Nn][Dd][Ee][Hh]") or msg.media.description:match("[Kk][Oo][Oo][Nn]") or msg.media.description:match("کیر") or msg.media.description:match("کسکش") or msg.media.description:match("کونی") or msg.media.description:match("جنده") or msg.media.description:match("حشری")
				badw_hash = 'badword:'..msg.to.id
				if is_badw_desc and redis:get(badw_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_emoji_desc = msg.media.description:match("[😀😬😁😂😃😄😅☺️🙃🙂😊😉😇😆😋😌😍😘😗😙😚🤗😎🤓🤑😛😝😜😏😶😐😑😒🙄🤔😕😔😡😠😟😞😳🙁☹️😣😖😫😩😤😧😦😯😰😨😱😮😢😥😪😓😭😵😲💩💤😴🤕🤒😷🤐😈👿👹👺💀👻👽😽😼😻😹😸😺🤖🙀😿😾🙌🏻👏🏻👋🏻👍🏻👎🏻👊🏻✊🏻✌🏻👌🏻✋🏻👐🏻💪🏻🙏🏻☝🏻️👆🏻👇🏻👈🏻👉🏻🖕🏻🖐🏻🤘🏻🖖🏻✍🏻💅🏻👄👅👂🏻👃🏻👁👀👤👥👱🏻👩🏻👨🏻👧🏻👦🏻👶🏻🗣👴🏻👵🏻👲🏻🏃🏻🚶🏻💑👩‍❤️‍👩👨‍❤️‍👨💏👩‍❤️‍💋‍👩👨‍❤️‍💋‍👨👪👩‍👩‍👧‍👦👩‍👩‍👧👩‍👩‍👦👨‍👩‍👧‍👧👨‍👩‍👦‍👦👨‍👩‍👧‍👦👨‍👩‍👧👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👘👙👗👔👖👕👚💄💋👣👠👡👢👞🎒⛑👑🎓🎩👒👟👝👛👜💼👓🕶💍🌂🐶🐱🐭🐹🐰🐻🐼🐸🐽🐷🐮🦁🐯🐨🐙🐵🙈🙉🙊🐒🐔🐗🐺🐥🐣🐤🐦🐧🐴🦄🐝🐛🐌🐞🐜🕷🦂🦀🐍🐢🐠🐟🐅🐆🐊🐋🐬🐡🐃🐂🐄🐪🐫🐘🐐🐓🐁🐀🐖🐎🐑🐏🦃🕊🐕]")
				emoji_hash = 'emoji:'..msg.to.id
				if is_emoji_desc and redis:get(emoji_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_eng_desc = msg.media.description:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]")
				eng_hash = 'english:'..msg.to.id
				if is_eng_desc and redis:get(eng_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
				local is_squig_desc = msg.media.description:match("[\216-\219][\128-\191]")
				ar_hash = 'arabic:'..msg.to.id
				if is_squig_desc and redis:get(ar_hash) then
					delete_msg(msg.id, ok_cb, false)
				end
			end
		if msg.media.caption then 
			local is_link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]")
				link_hash = 'links:'..msg.to.id
				if is_link_caption and redis:get(link_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_tag_caption = msg.media.caption:match("@")
				tag_hash = 'tag:'..msg.to.id
				if is_tag_caption and redis:get(tag_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_stick_caption = msg.media.caption:match(".webp")
				stick_hash = 'stickers:'..msg.to.id
				if is_stick_caption and redis:get(stick_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_hashtag_caption = msg.media.caption:match("#")
				hashtag_hash = 'hashtag:'..msg.to.id
				if is_hashtag_caption and redis:get(hashtag_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_webpage_caption = msg.media.caption:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.media.caption:match("[Hh][Tt][Tt][Pp]://") or msg.media.caption:match(".[Ii][Rr]") or msg.media.caption:match(".[Cc][Oo][Mm]") or msg.media.caption:match(".[Oo][Rr][Gg]") or msg.media.caption:match(".[Ii][Nn][Ff][Oo]") or msg.media.caption:match("[Ww][Ww][Ww].") or msg.media.caption:match(".[Tt][Kk]")
				weblink_hash = 'webpage:'..msg.to.id
				if is_webpage_caption and redis:get(weblink_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_emoji_caption = msg.media.caption:match("[😀😬😁😂😃😄😅☺️🙃🙂😊😉😇😆😋😌😍😘😗😙😚🤗😎🤓🤑😛😝😜😏😶😐😑😒🙄🤔😕😔😡😠😟😞😳🙁☹️😣😖😫😩😤😧😦😯😰😨😱😮😢😥😪😓😭😵😲💩💤😴🤕🤒😷🤐😈👿👹👺💀👻👽😽😼😻😹😸😺🤖🙀😿😾🙌🏻👏🏻👋🏻👍🏻👎🏻👊🏻✊🏻✌🏻👌🏻✋🏻👐🏻💪🏻🙏🏻☝🏻️👆🏻👇🏻👈🏻👉🏻🖕🏻🖐🏻🤘🏻🖖🏻✍🏻💅🏻👄👅👂🏻👃🏻👁👀👤👥👱🏻👩🏻👨🏻👧🏻👦🏻👶🏻🗣👴🏻👵🏻👲🏻🏃🏻🚶🏻💑👩‍❤️‍👩👨‍❤️‍👨💏👩‍❤️‍💋‍👩👨‍❤️‍💋‍👨👪👩‍👩‍👧‍👦👩‍👩‍👧👩‍👩‍👦👨‍👩‍👧‍👧👨‍👩‍👦‍👦👨‍👩‍👧‍👦👨‍👩‍👧👩‍👩‍👦‍👦👩‍👩‍👧‍👧👨‍👨‍👦👨‍👨‍👧👨‍👨‍👧‍👦👨‍👨‍👦‍👦👨‍👨‍👧‍👧👘👙👗👔👖👕👚💄💋👣👠👡👢👞🎒⛑👑🎓🎩👒👟👝👛👜💼👓🕶💍🌂🐶🐱🐭🐹🐰🐻🐼🐸🐽🐷🐮🦁🐯🐨🐙🐵🙈🙉🙊🐒🐔🐗🐺🐥🐣🐤🐦🐧🐴🦄🐝🐛🐌🐞🐜🕷🦂🦀🐍🐢🐠🐟🐅🐆🐊🐋🐬🐡🐃🐂🐄🐪🐫🐘🐐🐓🐁🐀🐖🐎🐑🐏🦃🕊🐕]")
				emoji_hash = 'emoji:'..msg.to.id
				if is_emoji_caption and redis:get(emoji_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_eng_caption = msg.media.caption:match("[ASDFGHJKLQWERTYUIOPZXCVBNMasdfghjklqwertyuiopzxcvbnm]")
				eng_hash = 'english:'..msg.to.id
				if is_eng_caption and redis:get(eng_hash) then
					delete_msg(msg.id, ok_cb, false)
			end
			local is_squig_caption = msg.media.caption:match("[\216-\219][\128-\191]")
					ar_hash = 'arabic:'..msg.to.id
					if is_squig_caption and redis:get(ar_hash) then
						delete_msg(msg.id, ok_cb, false)
			end
		end
	end
 --[[     --Checking stickers
        if not msg.media then
            webp = 'nothing'
        else
            webp = msg.media.caption
        end
        if webp == 'sticker.webp' then
            hash = 'stickers:'..msg.to.id
            if redis:get(hash) then
                delete_msg(msg.id, ok_cb, false)
            end
        end
        if not msg.media then
            mp4 = 'nothing'
        else
            if msg.media.type == 'document' then
                mp4 = msg.media.caption or 'audio'
            end
        end
        --Checking GIFs and MP4 files
        if mp4 == 'giphy.mp4' then
            hash = 'gifs:'..msg.to.id
            if redis:get(hash) then
                delete_msg(msg.id, ok_cb, false)
            end
        else
            if msg.media then --setflood
                if msg.media.type == 'document' then
                    gifytpe = string.find(mp4, 'gif.mp4') or 'audio'
                    if gifytpe == 'audio' then
                        hash = 'audio:'..msg.to.id
                        if redis:get(hash) then
                            delete_msg(msg.id, ok_cb, false)
                        end
                    else
                        hash = 'gifs:'..msg.to.id
                        if redis:get(hash) then
                            delete_msg(msg.id, ok_cb, false)
                        end
                    end
                end
            end
        end]]
		if msg.media then
			local is_gif_caption =  msg.media.caption and msg.media.caption:match("giphy.mp4")
			ghash = 'gifs:'..msg.to.id
			if redis:get(ghash) and is_gif_caption and msg.media.type:match("document") and not msg.service then
				delete_msg(msg.id, ok_cb, false)
			end
		end
        --Checking photos
        if msg.media then
            if msg.media.type == 'photo' then
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    delete_msg(msg.id, ok_cb, false)
                end
            end
        end
        --Checking texts
        if msg.text and not msg.media and not msg.service then
                local hash = 'texts:'..msg.to.id
                if redis:get(hash) then
                    delete_msg(msg.id, ok_cb, false)
                end
        end
        --Checking video 
        if msg.media then
            if msg.media.type == 'video' then
                local hash = 'video:'..msg.to.id
                if redis:get(hash) then
                    delete_msg(msg.id, ok_cb, false)
                end
            end
        end
		if msg.media then
		if msg.media.type:match("contact") then
                local hash = 'contact:'..msg.to.id
                if redis:get(hash) then
                    delete_msg(msg.id, ok_cb, false)
                end
            end
		end
		if msg.media then
		if msg.media.type:match("audio") and not msg.service then
		        local hash = 'audio:'..msg.to.id
                if redis:get(hash) then
				    delete_msg(msg.id, ok_cb, false)
				end
			end
		end
        --Checking forward
        if msg.fwd_from then
			 local hash = 'forward:'..msg.to.id
                if redis:get(hash) then
			    delete_msg(msg.id, ok_cb, false)
		end
	end
	--Checking reply
        if msg.reply_id then
			 local hash = 'reply:'..msg.to.id
                if redis:get(hash) then
			    delete_msg(msg.id, ok_cb, false)
		end
	end
        --Checking muteall
        local hash = 'muteall:'..msg.to.id
        if redis:get(hash) then
            delete_msg(msg.id, ok_cb, false)
        end
    else
        if msg.media then
            if msg.media.type == 'photo' then
                local hash = 'setphoto:'..msg.to.id..':'..msg.from.id
                if redis:get(hash) then
                    redis:del(hash)
                    load_photo(msg.id, set_group_photo, msg)
                    print('setphoto')
                end
            end
        end
		if msg.service then 
		    tg_hash = 'tgservices:'..msg.to.id
			if redis:get(tg_hash) then
				delete_msg(msg.id, ok_cb, false)
			end
		end
    return msg
end
    --Checking mute
	    local user_id = msg.from.id
        local chat_id = msg.to.id
     local muted = is_muteduser(user_id, msg.to.id)
    if muted then
        if msg.to.type == 'chat' then
            delete_msg(msg.id, ok_cb, true)
        elseif msg.to.type == 'channel' then
            delete_msg(msg.id, ok_cb, true)
        end
    end
	local user_id = msg.from.id
    local gmuted = is_gmuteduser(user_id)
    if gmuted then
        if msg.to.type == 'chat' then
            delete_msg(msg.id, ok_cb, true)
        elseif msg.to.type == 'channel' then
            delete_msg(msg.id, ok_cb, true)
        end
    end
    if msg.action and msg.action.type then
        local action = msg.action.type
        if action == 'chat_add_user' or action == 'chat_add_user_link' then
            local user_id
            local hash = 'lockmember:'..msg.to.id
            if redis:get(hash) then
                if msg.action.link_issuer then
                    user_id = msg.from.id
                else
                    user_id = msg.action.user.id
                end
                kick_user(user_id, msg.to.id)
                reply_msg(msg.id, 'You can,t add anyone to this group because the members are locked\nIf you want to unlock members please use the code below \n /unlock member\n------------------\nبه دلیل قفل بودن اعضا کاربر از گروه حذف شد.\nبرای غیر فعال کردن این قابلیت از دستور زیر استفاده کنید.\n /unlock member', ok_cb, false)
            end
            if msg.action.link_issuer then
                user_id = msg.from.id
            else
                user_id = msg.action.user.id
            end 
            print('Checking invited user '..user_id)
            local banned = is_banned(user_id, msg.to.id) or is_gbanned(user_id)
            if banned then
                print('User is banned!')
                kick_user(user_id, msg.to.id)
            end
        end
        return msg
    end
    if msg.to.type == 'chat' or msg.to.type == 'channel' then
        local user_id = msg.from.id
        local chat_id = msg.to.id
        local banned = is_banned(user_id, chat_id) or is_gbanned(user_id, msg.to.id)
        if banned then
            print('Banned user talking!')
            kick_user(user_id, chat_id)
            msg.text = ''
        end
    return msg
   end
end

local function run(msg, matches)
local glang = redis:get('cmdset:'..msg.to.id)
   if glang then
        lang = redis:get('cmdset:'..msg.to.id)
   elseif not glang then
        lang = 'en'
   end
if msg.to.type == 'chat' or msg.to.type == 'channel' then
        local cmds = 'cmds:'..msg.to.id
		local cmdscheck =  redis:get(cmds) 
    if cmdscheck and not permissions(msg.from.id, msg.to.id, "settings") then 
	  return
		else
    if matches[1]:lower() == 'lock' then
        if permissions(msg.from.id, msg.to.id, "settings") then
                if matches[2]:lower() == 'sticker' then
                        hash = 'stickers:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noStickersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noStickersL'), ok_cb, false)
                        end
                    return
					elseif matches[2]:lower() == 'tgservice' then
                        hash = 'tgservices:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'tgservicesT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'tgservicesL'), ok_cb, false)
                        end
                    return
					elseif matches[2]:lower() == 'forward' then
                        hash = 'forward:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noforwardT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noforwardL'), ok_cb, false)
                        end
                    return
					elseif matches[2]:lower() == 'reply' then
                        hash = 'reply:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noreplyT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noreplyL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'links' then
                        hash = 'links:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noLinksT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noLinksL'), ok_cb, false)
                    end
            return
                elseif matches[2]:lower() == 'contacts' then
                        hash = 'contact:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nocontactT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nocontactL'), ok_cb, false)
                    end
            return
			    elseif matches[2]:lower() == 'tag' then
                        hash = 'tag:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noTagT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noTagL'), ok_cb, false)
                    end
            return
			    elseif matches[2]:lower() == 'webpage' then
                        hash = 'webpage:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nowebpageT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nowebpageL'), ok_cb, false)
                    end
            return
			    elseif matches[2]:lower() == 'cmds' then
                        hash = 'cmds:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noCmds'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noCmdsL'), ok_cb, false)
                    end
            return
			    elseif matches[2]:lower() == 'badword' then
                        hash = 'badword:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nobadwordT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nobadwordL'), ok_cb, false)
                    end
            return
			    elseif matches[2]:lower() == 'english' then
                        hash = 'english:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noenglishT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noenglishL'), ok_cb, false)
                    end
            return
			    elseif matches[2]:lower() == 'emoji' then
                        hash = 'emoji:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noemojiT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noemojiL'), ok_cb, false)
                    end
            return
			    elseif matches[2]:lower() == 'hashtag' then
                        hash = 'hashtag:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nohashtagT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'nohashtagL'), ok_cb, false)
                    end
            return
                elseif matches[2]:lower() == 'bots' then
                        hash = 'antibot:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noBotsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noBotsL'), ok_cb, false)
                        end
                    return
                 elseif matches[2]:lower() == 'arabic' then
                        hash = 'arabic:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noArabicT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noArabicL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'kickme' then
                        hash = 'kickme:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noKickmeT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noKickmeL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'flood' then
                        hash = 'anti-flood:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noFloodT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noFloodL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'spam' then
                        local hash = 'spam:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notAllowedSpamT'), ok_cb, true)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notAllowedSpamL'), ok_cb, true)
                        end
                elseif matches[2]:lower() == 'member' then
				        local hash = 'lockmember:'..msg.to.id
						redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notLockMembersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notLockMembersT'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'setname' then
                        local hash = 'name:enabled:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notChatRename'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notChannelRename'), ok_cb, false)
                        end
                    elseif matches[2]:lower() == 'setphoto' then
                        local hash = 'setphoto:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notChatSetphoto'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notChannelSetphoto'), ok_cb, false)
                     end
                end
			end
		end
    if matches[1]:lower() == 'unlock' then
        if permissions(msg.from.id, msg.to.id, "settings") then
                    if matches[2]:lower() == 'sticker' then
                        hash = 'stickers:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'stickersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'stickersL'), ok_cb, false)
                        end
                    return
		elseif matches[2]:lower() == 'tgservice' then
                     hash = 'tgservices:'..msg.to.id
                     redis:del(hash)
                       	if msg.to.type == 'chat' then
              		        reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noTgservicesT'), ok_cb, false)
                             elseif msg.to.type == 'channel' then
                       		reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noTgservicesT'), ok_cb, false)
                    end
                    return
					elseif matches[2]:lower() == 'forward' then
                        hash = 'forward:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'forwardT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'forwardL'), ok_cb, false)
                        end
                    return
					elseif matches[2]:lower() == 'reply' then
                        hash = 'reply:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'replyT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'replyL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'links' then
                        hash = 'links:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'LinksT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'LinksL'), ok_cb, false)
                        end
            return
			elseif matches[2]:lower() == 'contacts' then
                        hash = 'contact:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'contactT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'contactL'), ok_cb, false)
                        end
            return
			    elseif matches[2]:lower() == 'tag' then
                        hash = 'tag:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                           reply_msg(msg.id, ' '..lang_text(msg.to.id, 'TagT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                           reply_msg(msg.id, ' '..lang_text(msg.to.id, 'TagL'), ok_cb, false)
                        end
            return
                elseif matches[2]:lower() == 'webpage' then
                        hash = 'webpage:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'webpageT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'webpageL'), ok_cb, false)
                        end
            return
			elseif matches[2]:lower() == 'cmds' then
                        hash = 'cmds:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'CmdsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'CmdsL'), ok_cb, false)
                        end
            return
                elseif matches[2]:lower() == 'english' then
                        hash = 'english:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'englishT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'englishL'), ok_cb, false)
                        end
            return
                elseif matches[2]:lower() == 'badword' then
                        hash = 'badword:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'badwordT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'badwordL'), ok_cb, false)
                        end
            return
                elseif matches[2]:lower() == 'emoji' then
                        hash = 'emoji:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'emojiT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'emojiL'), ok_cb, false)
                        end
            return
                elseif matches[2]:lower() == 'hashtag' then
                        hash = 'hashtag:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'hashtagT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'hashtagL'), ok_cb, false)
                        end
            return
                elseif matches[2]:lower() == 'bots' then
                        hash = 'antibot:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'botsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'botsL'), ok_cb, false)
                        end
                    return
                 elseif matches[2]:lower() == 'arabic' then
                        hash = 'arabic:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'arabicT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'arabicL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'kickme' then
                        hash = 'kickme:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'kickmeT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'kickmeL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'flood' then
                        hash = 'anti-flood:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'floodT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'floodL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'spam' then
                        local hash = 'spam:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                           reply_msg(msg.id, ' '..lang_text(msg.to.id, 'allowedSpamT'), ok_cb, true)
                        elseif msg.to.type == 'channel' then
                           reply_msg(msg.id, ' '..lang_text(msg.to.id, 'allowedSpamL'), ok_cb, true)
                        end
                elseif matches[2]:lower() == 'member' then
                    hash = 'lockmember:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'lockMembersT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'lockMembersL'), ok_cb, false)
                        end
                    return
                elseif matches[2]:lower() == 'setname' then
                        local hash = 'name:enabled:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                           reply_msg(msg.id, ' '..lang_text(msg.to.id, 'chatRename'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'channelRename'), ok_cb, false)
                        end
                    elseif matches[2]:lower() == 'setphoto' then
                        local hash = 'setphoto:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'chatSetphoto'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'channelSetphoto'), ok_cb, false)
                    end
				end
			end
		end
    if matches[1]:lower() == 'mute' then
        if permissions(msg.from.id, msg.to.id, "settings") then
		                if matches[2]:lower() == 'gifs' then
                        hash = 'gifs:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noGifsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noGifsL'), ok_cb, false)
                        end
                    return
		                elseif matches[2]:lower() == 'photo' then
                        hash = 'photo:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noPhotosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noPhotosL'), ok_cb, false)
                        end
                    return
				        elseif matches[2]:lower() == 'video' then
                        hash = 'video:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'novideoT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'novideoL'), ok_cb, false)
                        end
                    return
					elseif matches[2]:lower() == 'text' then
                        hash = 'texts:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notextsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'notextsL'), ok_cb, false)
                        end
                    return
		                elseif matches[2]:lower() == 'audio' then
                        hash = 'audio:'..msg.to.id
                        redis:set(hash, true)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noAudiosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noAudiosL'), ok_cb, false)
                    end
				end
			end
		end	
	if matches[1]:lower() == 'unmute' then
        if permissions(msg.from.id, msg.to.id, "settings") then
		                if matches[2]:lower() == 'gifs' then
                        hash = 'gifs:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'gifsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'gifsL'), ok_cb, false)
                        end
                    return
	 elseif matches[2]:lower() == 'photo' then
                        hash = 'photo:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'photosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, '? '..lang_text(msg.to.id, 'photosL'), ok_cb, false)
                        end
                    return
		 elseif matches[2]:lower() == 'video' then
                        hash = 'video:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'videoT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, '? '..lang_text(msg.to.id, 'videoL'), ok_cb, false)
                        end
                    return
					elseif matches[2]:lower() == 'text' then
                        hash = 'texts:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'textsT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'textsL'), ok_cb, false)
                        end
                    return
	 elseif matches[2]:lower() == 'audio' then
                        hash = 'audio:'..msg.to.id
                        redis:del(hash)
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'audiosT'), ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'audiosL'), ok_cb, false)
                    end
				end
			end
		end
	local receiver = get_receiver(msg)
    if matches[1]:lower() == 'set welcome' then
		if not permissions(msg.from.id, msg.to.id, "welcome") then
			return 
		end
      local hash = 'welcome:'..msg.to.id
      redis:set(hash, matches[2])
      return reply_msg(msg.id,lang_text(msg.to.id, 'welnew').. ' '..matches[2],ok_cb,false)
   elseif matches[1]:lower() == 'get welcome' then
      local hash = 'welcome:'..msg.to.id
      local wel = redis:get(hash)
      if not wel then
         return reply_msg(msg.id,lang_text(msg.to.id, 'nogwlc'),ok_cb,false)
      end
      return reply_msg(msg.id,lang_text(msg.to.id, 'gwlc')..''..wel,ok_cb,false)
   elseif matches[1]:lower() == 'welcome on' and permissions(msg.from.id, msg.to.id, "welcome") then
      local hashst = 'wlstat:'..msg.to.id
     redis:set(hashst, 'on')
      local hash = 'wlcstatus:'..msg.to.id
      redis:set(hash, 'on')
      return reply_msg(msg.id,lang_text(msg.to.id, 'welon'),ok_cb,false)
   elseif matches[1]:lower() == 'welcome off' and permissions(msg.from.id, msg.to.id, "welcome") then
   local hashst = 'wlstat:'..msg.to.id
     redis:del(hashst)
      local hash = 'wlcstatus:'..msg.to.id
      redis:set(hash, 'off')
      return reply_msg(msg.id,lang_text(msg.to.id, 'weloff'),ok_cb,false)
   end
		    if matches[1]:lower() == 'setfloodtime' then
			   	if tonumber(matches[2]) < 2 then
			         return reply_msg(msg.id, ' '..lang_text(msg.to.id, 'errflood'), ok_cb, false)
				 end
				  if permissions(msg.from.id, msg.to.id, "settings") then
                    if not matches[2] then
                    else
                        hash = 'flood:time:'..msg.to.id
                        redis:set(hash, matches[2])
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'floodTime')..matches[2], ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'floodTime')..matches[2], ok_cb, false)
                        end
                    end
				end
                    return
				end
         if matches[1]:lower() == 'setflood' then
			 if tonumber(matches[2]) < 2 then
			    return reply_msg(msg.id, ' '..lang_text(msg.to.id, 'errflood'), ok_cb, false)
			 end
				if permissions(msg.from.id, msg.to.id, "settings") then
                    if not matches[2] then
                    else
                        hash = 'flood:max:'..msg.to.id
                        redis:set(hash, matches[2])
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'floodMax')..matches[2], ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'floodMax')..matches[2], ok_cb, false)
                        end
                    return
				end 
			 end
		  end
         if matches[1]:lower() == 'setchar' then
			 if tonumber(matches[2]) < 1000 then
			    return reply_msg(msg.id, ' '..lang_text(msg.to.id, 'errchar'), ok_cb, false)
			 end
				if permissions(msg.from.id, msg.to.id, "settings") then
                    if not matches[2] then
                    else
                        hash = 'maxchar:'..msg.to.id
                        redis:set(hash, matches[2])
                        if msg.to.type == 'chat' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'charmax')..matches[2], ok_cb, false)
                        elseif msg.to.type == 'channel' then
                            reply_msg(msg.id, ' '..lang_text(msg.to.id, 'charmax')..matches[2], ok_cb, false)
                        end
                    return
				end
			 end
		  end
		if matches[1]:lower() == 'settings' and not matches[2] then
				   if permissions(msg.from.id, msg.to.id, "settings") then
                if msg.to.type == 'chat' then
                    text = ' '..lang_text(msg.to.id, 'gSettings')..' ['..msg.to.title..'] :\n\n'
                elseif msg.to.type == 'channel' then
                    text = ' '..lang_text(msg.to.id, 'sSettings')..' ['..msg.to.title..'] :\n\n'
                local allowed = lang_text(msg.to.id, 'allowed')
				local alloweds = lang_text(msg.to.id, 'alloweds')
				local noAlloweds = lang_text(msg.to.id, 'noAlloweds')
				local unlm = lang_text(msg.to.id, 'unlm')
                local noAllowed = lang_text(msg.to.id, 'noAllowed')
                local le = lang_text(msg.to.id, 'le')
                local ld = lang_text(msg.to.id, 'ld')
				
				--Enable/disable Group Welcome
                local hash = 'wlstat:'..msg.to.id
                if redis:get(hash) then
                    sgpwlc = le
                    sgpwlcD = ''
                else
                    sgpwlc = ld
                    sgpwlcD = ''
                end
                text = text..sgpwlcD..' '..lang_text(msg.to.id, 'gpwlc')..' > '..sgpwlc..'\n'

                --Enable/disable Stickers
                local hash = 'stickers:'..msg.to.id
                if redis:get(hash) then
                    sStickers = noAllowed
                    sStickersD = ''
                else
                    sStickers = allowed
                    sStickersD = ''
                end
                text = text..sStickersD..' '..lang_text(msg.to.id, 'stickers')..' > '..sStickers..'\n'

		        --Enable/disable Tgservices
                local hash = 'tgservices:'..msg.to.id
                if redis:get(hash) then
                    tTgservices = noAllowed
                    tTgservicesD = ''
                else
                    tTgservices = allowed
                    tTgservicesD = ''
                end
                text = text..tTgservicesD..' '..lang_text(msg.to.id, 'tgservices')..' > '..tTgservices..'\n'

                --Enable/disable Links
                local hash = 'links:'..msg.to.id
                if redis:get(hash) then
                    sLink = noAllowed
                    sLinkD = ''
                else
                    sLink = allowed
                    sLinkD = ''
                end
                text = text..sLinkD..' '..lang_text(msg.to.id, 'links')..' > '..sLink..'\n'

				--Enable/disable webpage
                local hash = 'webpage:'..msg.to.id
                if redis:get(hash) then
                    swebpage = noAllowed
                    swebpageD = ''
                else
                    swebpage = allowed
                    swebpageD = ''
                end
                text = text..swebpageD..' '..lang_text(msg.to.id, 'webpage')..' > '..swebpage..'\n'
				
                --Enable/disable Tag
                local hash = 'tag:'..msg.to.id
                if redis:get(hash) then
                    sTag = noAllowed
                    sTagD = ''
                else
                    sTag = allowed
                    sTagD = ''
                end
                text = text..sTagD..' '..lang_text(msg.to.id, 'tag')..' > '..sTag..'\n'
				
				--Enable/disable hashtag
				local hash = 'hashtag:'..msg.to.id
                if redis:get(hash) then
                    shashtag = noAllowed
                    shashtagD = ''
                else
                    shashtag = allowed
                    shashtagD = ''
                end
                text = text..shashtagD..' '..lang_text(msg.to.id, 'hashtag')..' > '..shashtag..'\n'
				
				--Enable/disable emoji
                local hash = 'emoji:'..msg.to.id
                if redis:get(hash) then
                    semoji = noAllowed
                    semojiD = ''
                else
                    semoji = allowed
                    semojiD = ''
                end
                text = text..semojiD..' '..lang_text(msg.to.id, 'emoji')..' > '..semoji..'\n'
				
				--Enable/disable contacts
                local hash = 'contact:'..msg.to.id
                if redis:get(hash) then
                    scontact = noAllowed
                    scontactD = ''
                else
                    scontact = allowed
                    scontactD = ''
                end
                text = text..scontactD..' '..lang_text(msg.to.id, 'contact')..' > '..scontact..'\n'
				
				--Enable/disable english
                local hash = 'english:'..msg.to.id
                if redis:get(hash) then
                    senglish = noAllowed
                    senglishD = ''
                else
                    senglish = allowed
                    senglishD = ''
                end
                text = text..senglishD..' '..lang_text(msg.to.id, 'english')..' > '..senglish..'\n'
				
			    --Enable/disable arabic messages
                local hash = 'arabic:'..msg.to.id
                if not redis:get(hash) then
                    sArabe = allowed
                    sArabeD = ''              
                else
                    sArabe = noAllowed
                    sArabeD = ''
                end
                text = text..sArabeD..' '..lang_text(msg.to.id, 'arabic')..' > '..sArabe..'\n'

				--Enable/disable forward
                local hash = 'forward:'..msg.to.id
                if redis:get(hash) then
                    sforward = noAllowed
                    sforwardD = ''
                else
                    sforward = allowed
                    sforwardD = ''
                end
                text = text..sforwardD..' '..lang_text(msg.to.id, 'forward')..' > '..sforward..'\n'
				
				--Enable/disable reply
                local hash = 'reply:'..msg.to.id
                if redis:get(hash) then
                    sreply = noAllowed
                    sreplyD = ''
                else
                    sreply = allowed
                    sreplyD = ''
                end
                text = text..sreplyD..' '..lang_text(msg.to.id, 'reply')..' > '..sreply..'\n'
				
				--Enable/disable badword
                local hash = 'badword:'..msg.to.id
                if redis:get(hash) then
                    sbadword = noAllowed
                    sbadwordD = ''
                else
                    sbadword = allowed
                    sbadwordD = ''
                end
                text = text..sbadwordD..' '..lang_text(msg.to.id, 'badword')..' > '..sbadword..'\n'
				
                --Enable/disable bots
                local hash = 'antibot:'..msg.to.id
                if not redis:get(hash) then
                    sBots = allowed
                    sBotsD = ''
                else
                    sBots = noAllowed
                    sBotsD = ''
                end
                text = text..sBotsD..' '..lang_text(msg.to.id, 'bots')..' > '..sBots..'\n'
                
                --Enable/disable kickme
                local hash = 'kickme:'..msg.to.id
                if redis:get(hash) then
                    sKickme = allowed
                    sKickmeD = ''
                else
                    sKickme = noAllowed
                    sKickmeD = ''
                end
                text = text..sKickmeD..' '..lang_text(msg.to.id, 'kickme')..' > '..sKickme..'\n'

                --Enable/disable spam
                local hash = 'spam:'..msg.to.id
                if redis:get(hash) then
                    sSpam = noAllowed
                    sSpamD = ''
                else
                    sSpam = allowed
                    sSpamD = ''
                end
                text = text..sSpamD..' '..lang_text(msg.to.id, 'spam')..' > '..sSpam..'\n'

				--Lock/unlock numbers of channel members
                local hash = 'lockmember:'..msg.to.id
                if redis:get(hash) then
                    sLock = noAllowed
                    sLockD = ''
                else
                    sLock = allowed
                    sLockD = ''
                end
                text = text..sLockD..' '..lang_text(msg.to.id, 'lockmmr')..' > '..sLock..'\n'
                --Enable/disable setphoto
                local hash = 'setphoto:'..msg.to.id
                if not redis:get(hash) then
                    sSPhoto = allowed
                    sSPhotoD = ''
                else
                    sSPhoto = noAllowed
                    sSPhotoD = ''
                end
                text = text..sSPhotoD..' '..lang_text(msg.to.id, 'setphoto')..' > '..sSPhoto..'\n'

                --Enable/disable changing group name
                local hash = 'name:enabled:'..msg.to.id
                if redis:get(hash) then
                    sName = noAllowed
                    sNameD = ''
                else
                    sName = allowed
                    sNameD = ''
                end
                text = text..sNameD..' '..lang_text(msg.to.id, 'gName')..' > '..sName..'\n'

			   --Enable/disable Flood
                local hash = 'anti-flood:'..msg.to.id
                if redis:get(hash) then
                    sFlood = allowed
                    sFloodD = ''
                else
                    sFlood = noAllowed
                    sFloodD = ''
                end
                text = text..sFloodD..' '..lang_text(msg.to.id, 'flood')..' > '..sFlood..'\n'
				
				--Enable/disable maxchar
                local numbhash = 'maxchar:'..msg.to.id
                if redis:get(numbhash) then
                    sChar = tonumber(redis:get(numbhash))
                    sCharD = ''
                else
                    sChar = '4096'
                    sCharD = ''
                end
                text = text..sCharD..' '..lang_text(msg.to.id, 'gchar')..' > <b>'..sChar..'</b>\n'

                local hash = 'flood:max:'..msg.to.id
                if not redis:get(hash) then
                    floodMax = 5
                else
                    floodMax = redis:get(hash)
                end

                local hash = 'flood:time:'..msg.to.id
                if not redis:get(hash) then
                    floodTime = 3
                else
                    floodTime = redis:get(hash)
                end

               	text = text..' '..lang_text(msg.to.id, 'mFlood')..' > <b>'..floodMax..'</b>\n '..lang_text(msg.to.id, 'tFlood')..' > <b>'..floodTime..'</b>\n______________________\n<b>Mutes List:</b>\n\n'            
               
			    --Enable/disable muteall
                local hash = 'muteall:'..msg.to.id
                if redis:get(hash) then
                    smuteall = noAlloweds
                    smuteallD = ''
                else
                    smuteall = alloweds
                    smuteallD = ''
                end
                text = text..smuteallD..' '..lang_text(msg.to.id, 'muteall')..' > '..smuteall..'\n'
				--Enable/disable send Text
                local hash = 'texts:'..msg.to.id
                if redis:get(hash) then
                    stexts = noAlloweds
                    stextsD = ''
                else
                    stexts = alloweds
                    stextsD = ''
                end
                text = text..stextsD..' '..lang_text(msg.to.id, 'texts')..' > '..stexts..'\n'
				--Enable/disable send photos
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    sPhoto = noAlloweds
                    sPhotoD = ''
                else
                    sPhoto = alloweds
                    sPhotoD = ''
                end
                text = text..sPhotoD..' '..lang_text(msg.to.id, 'photos')..' > '..sPhoto..'\n'
				--Enable/disable send videos
                local hash = 'video:'..msg.to.id
                if redis:get(hash) then
                    svideo = noAlloweds
                    svideoD = ''
                else
                    svideo = alloweds
                    svideoD = ''
                end
                text = text..svideoD..' '..lang_text(msg.to.id, 'video')..' > '..svideo..'\n'

				--Enable/disable gifs
                local hash = 'gifs:'..msg.to.id
                if redis:get(hash) then
                    sGif = noAlloweds
                    sGifD = ''
                else
                    sGif = alloweds
                    sGifD = ''
                end
                text = text..sGifD..' '..lang_text(msg.to.id, 'gifs')..' > '..sGif..'\n'
                
				--Enable/disable send audios
                local hash = 'audio:'..msg.to.id
                if redis:get(hash) then
                    sAudio = noAlloweds
                    sAudioD = ''
                else
                    sAudio = alloweds
                    sAudioD = ''
                end
                text = text..sAudioD..' '..lang_text(msg.to.id, 'audios')..' > '..sAudio..'\n_____________________________\n'
								
				--Enable/disable Group Cmds
                local hash = 'cmds:'..msg.to.id
                if redis:get(hash) then
                    scmds = ld
                    scmdsD = ''
                else
                    scmds = le
                    scmdsD = ''
                end
                text = text..scmdsD..' '..lang_text(msg.to.id, 'cmds')..' > '..scmds..'\n'
				--Show Group Lang
                local hash = 'langset:'..msg.to.id
                if redis:get(hash) then
                    sLang = redis:get(hash)
                    sLangD = ''
                else
                    sLang = lang_text(msg.to.id, 'noSet')
                    sLangD = ''
                end
                text = text..sLangD..' '..lang_text(msg.to.id, 'language')..' > <b>'..string.upper(sLang)..'</b>\n'
               
				--Show Expire Date
                local ex = redis:ttl("charged:"..msg.to.id)
                if ex == -1 then
                    sCharge = unlm
					sChargeD = ''
					else
					local d = math.floor(ex / day) + 1
                    sCharge =  d
                    sChargeD = ''
				end
                text = text..sChargeD..' '..lang_text(msg.to.id, 'gpcharge')..' > <b>'..sCharge..'</b> '..lang_text(msg.to.id, 'gpcharge2')..'\n'
                --Send settings to group or supergroup
                if msg.to.type == 'chat' and matches[1]:lower() == 'settings' then
                    reply_msg(msg.id, text, ok_cb, false)
                elseif msg.to.type == 'channel' and matches[1]:lower() == 'settings' then
                    reply_msg(msg.id, text, ok_cb, false)
            end
		end
	end
end
if matches[1]:lower() == 'settings' and matches[2] then
	if permissions(msg.from.id, msg.to.id, "settings") then
                if msg.to.type == 'chat' or 'channel' then
                local allowed = lang_text(msg.to.id, 'allowed')
                local noAllowed = lang_text(msg.to.id, 'noAllowed')
                local le = lang_text(msg.to.id, 'le')
                local ld = lang_text(msg.to.id, 'ld')
				local alloweds = lang_text(msg.to.id, 'alloweds')
				local noAlloweds = lang_text(msg.to.id, 'noAlloweds')
				
			if matches[2]:lower() == 'welcome' then
                local hash = 'wlstat:'..msg.to.id
                if redis:get(hash) then
                    sgpwlc = le
                    sgpwlcD = ''
                else
                    sgpwlc = ld
                    sgpwlcD = ''
                end
                texta = lang_text(msg.to.id, 'gpwlc')..' > '..sgpwlc..'\n'
				reply_msg(msg.id,texta,ok_cb,false)
		    end
			if matches[2]:lower() == 'cmds' then
                local hash = 'cmds:'..msg.to.id
                if redis:get(hash) then
                    scmds = ld
                    scmdsD = ''
                else
                    scmds = le
                    scmdsD = ''
                end
                text = lang_text(msg.to.id, 'cmds')..' > '..scmds..'\n'
				reply_msg(msg.id,text,ok_cb,false)
			end
			if matches[2]:lower() == 'stickers' then
                local hash = 'stickers:'..msg.to.id
                if redis:get(hash) then
                    sStickers = noAllowed
                    sStickersD = ''
                else
                    sStickers = allowed
                    sStickersD = ''
                end
                text = lang_text(msg.to.id, 'stickers')..' > '..sStickers..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'tgservice' then
                local hash = 'tgservices:'..msg.to.id
                if redis:get(hash) then
                    tTgservices = noAllowed
                    tTgservicesD = ''
                else
                    tTgservices = allowed
                    tTgservicesD = ''
                end
                text = lang_text(msg.to.id, 'tgservices')..' > '..tTgservices..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'links' then
                local hash = 'links:'..msg.to.id
                if redis:get(hash) then
                    sLink = noAllowed
                    sLinkD = ''
                else
                    sLink = allowed
                    sLinkD = ''
                end
                text = lang_text(msg.to.id, 'links')..' > '..sLink..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'webpage' then
                local hash = 'webpage:'..msg.to.id
                if redis:get(hash) then
                    swebpage = noAllowed
                    swebpageD = ''
                else
                    swebpage = allowed
                    swebpageD = ''
                end
                text = lang_text(msg.to.id, 'webpage')..' > '..swebpage..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'tag' then
                local hash = 'tag:'..msg.to.id
                if redis:get(hash) then
                    sTag = noAllowed
                    sTagD = ''
                else
                    sTag = allowed
                    sTagD = ''
                end
                text = lang_text(msg.to.id, 'tag')..' > '..sTag..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'hashtag' then
				local hash = 'hashtag:'..msg.to.id
                if redis:get(hash) then
                    shashtag = noAllowed
                    shashtagD = ''
                else
                    shashtag = allowed
                    shashtagD = ''
                end
                text = lang_text(msg.to.id, 'hashtag')..' > '..shashtag..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'emoji' then
                local hash = 'emoji:'..msg.to.id
                if redis:get(hash) then
                    semoji = noAllowed
                    semojiD = ''
                else
                    semoji = allowed
                    semojiD = ''
                end
                text = lang_text(msg.to.id, 'emoji')..' > '..semoji..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'contacts' then
                local hash = 'contact:'..msg.to.id
                if redis:get(hash) then
                    scontact = noAllowed
                    scontactD = ''
                else
                    scontact = allowed
                    scontactD = ''
                end
                text = lang_text(msg.to.id, 'contact')..' > '..scontact..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'english' then
                local hash = 'english:'..msg.to.id
                if redis:get(hash) then
                    senglish = noAllowed
                    senglishD = ''
                else
                    senglish = allowed
                    senglishD = ''
                end
                text = lang_text(msg.to.id, 'english')..' > '..senglish..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'arabic' then
                local hash = 'arabic:'..msg.to.id
                if not redis:get(hash) then
                    sArabe = allowed
                    sArabeD = ''              
                else
                    sArabe = noAllowed
                    sArabeD = ''
                end
                text = lang_text(msg.to.id, 'arabic')..' > '..sArabe..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'forward' then
                local hash = 'forward:'..msg.to.id
                if redis:get(hash) then
                    sforward = noAllowed
                    sforwardD = ''
                else
                    sforward = allowed
                    sforwardD = ''
                end
                text = lang_text(msg.to.id, 'forward')..' > '..sforward..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'reply' then
                local hash = 'reply:'..msg.to.id
                if redis:get(hash) then
                    sreply = noAllowed
                    sreplyD = ''
                else
                    sreply = allowed
                    sreplyD = ''
                end
                text = lang_text(msg.to.id, 'reply')..' > '..sreply..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'badword' then
                local hash = 'badword:'..msg.to.id
                if redis:get(hash) then
                    sbadword = noAllowed
                    sbadwordD = ''
                else
                    sbadword = allowed
                    sbadwordD = ''
                end
                text = lang_text(msg.to.id, 'badword')..' > '..sbadword..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'bots' then
                local hash = 'antibot:'..msg.to.id
                if not redis:get(hash) then
                    sBots = allowed
                    sBotsD = ''
                else
                    sBots = noAllowed
                    sBotsD = ''
                end
                text = lang_text(msg.to.id, 'bots')..' > '..sBots..'\n'
                				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'kickme' then
                local hash = 'kickme:'..msg.to.id
                if redis:get(hash) then
                    sKickme = allowed
                    sKickmeD = ''
                else
                    sKickme = noAllowed
                    sKickmeD = ''
                end
                text = lang_text(msg.to.id, 'kickme')..' > '..sKickme..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'spam' then
                local hash = 'spam:'..msg.to.id
                if redis:get(hash) then
                    sSpam = noAllowed
                    sSpamD = ''
                else
                    sSpam = allowed
                    sSpamD = ''
                end
                text = lang_text(msg.to.id, 'spam')..' > '..sSpam..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'member' then
                local hash = 'lockmember:'..msg.to.id
                if redis:get(hash) then
                    sLock = noAllowed
                    sLockD = ''
                else
                    sLock = allowed
                    sLockD = ''
                end
                text = lang_text(msg.to.id, 'lockmmr')..' > '..sLock..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'setphoto' then
                local hash = 'setphoto:'..msg.to.id
                if not redis:get(hash) then
                    sSPhoto = allowed
                    sSPhotoD = ''
                else
                    sSPhoto = noAllowed
                    sSPhotoD = ''
                end
                text = lang_text(msg.to.id, 'setphoto')..' > '..sSPhoto..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'name' then
                local hash = 'name:enabled:'..msg.to.id
                if redis:get(hash) then
                    sName = noAllowed
                    sNameD = ''
                else
                    sName = allowed
                    sNameD = ''
                end
                text = lang_text(msg.to.id, 'gName')..' > '..sName..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'lang' then
                local hash = 'langset:'..msg.to.id
                if redis:get(hash) then
                    sLang = redis:get(hash)
                    sLangD = ''
                else
                    sLang = lang_text(msg.to.id, 'noSet')
                    sLangD = ''
                end
                text = lang_text(msg.to.id, 'language')..' > '..string.upper(sLang)..'\n'
               				reply_msg(msg.id,text,ok_cb,false)
		    end
			  if matches[2]:lower() == 'flood' then
                local hash = 'anti-flood:'..msg.to.id
                if redis:get(hash) then
                    sFlood = allowed
                    sFloodD = ''
                else
                    sFlood = noAllowed
                    sFloodD = ''
                end

                local hash = 'flood:max:'..msg.to.id
                if not redis:get(hash) then
                    floodMax = 5
                else
                    floodMax = redis:get(hash)
                end

                local hash = 'flood:time:'..msg.to.id
                if not redis:get(hash) then
                    floodTime = 3
                else
                    floodTime = redis:get(hash)
                end

               	textss = lang_text(msg.to.id, 'flood')..' > '..sFlood..'\n'..lang_text(msg.to.id, 'mFlood')..' > '..floodMax..'\n'..lang_text(msg.to.id, 'tFlood')..' > '..floodTime       
                              				reply_msg(msg.id,textss,ok_cb,false)
										end
			if matches[2]:lower() == 'mute all' then
                local hash = 'muteall:'..msg.to.id
                if redis:get(hash) then
                    smuteall = noAlloweds
                    smuteallD = ''
                else
                    smuteall = alloweds
                    smuteallD = ''
                end
                text = lang_text(msg.to.id, 'muteall')..' > '..smuteall..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'text' then
                local hash = 'texts:'..msg.to.id
                if redis:get(hash) then
                    stexts = noAlloweds
                    stextsD = ''
                else
                    stexts = alloweds
                    stextsD = ''
                end
                text = lang_text(msg.to.id, 'texts')..' > '..stexts..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'photo' then
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    sPhoto = noAlloweds
                    sPhotoD = ''
                else
                    sPhoto = alloweds
                    sPhotoD = ''
                end
                text = lang_text(msg.to.id, 'photos')..' > '..sPhoto..'\n'
								reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'video' then
                local hash = 'video:'..msg.to.id
                if redis:get(hash) then
                    svideo = noAlloweds
                    svideoD = ''
                else
                    svideo = alloweds
                    svideoD = ''
                end
                text = lang_text(msg.to.id, 'video')..' > '..svideo..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'gifs' then
                local hash = 'gifs:'..msg.to.id
                if redis:get(hash) then
                    sGif = noAlloweds
                    sGifD = ''
                else
                    sGif = alloweds
                    sGifD = ''
                end
                text = lang_text(msg.to.id, 'gifs')..' > '..sGif..'\n'
                				reply_msg(msg.id,text,ok_cb,false)
		    end
			if matches[2]:lower() == 'audio' then
                local hash = 'audio:'..msg.to.id
                if redis:get(hash) then
                    sAudio = noAlloweds
                    sAudioD = ''
                else
                    sAudio = alloweds
                    sAudioD = ''
                end
                text = lang_text(msg.to.id, 'audios')..' > '..sAudio..'\n'
				reply_msg(msg.id,text,ok_cb,false)
		    end
		end
	end
end
				if matches[1]:lower() == 'muteslist' then
				   if permissions(msg.from.id, msg.to.id, "settings") then
                if msg.to.type == 'chat' then
                    text = ' '..lang_text(msg.to.id, 'gmuteslist')..' ['..msg.to.title..'] :\n\n'
                elseif msg.to.type == 'channel' then
                    text = ' '..lang_text(msg.to.id, 'smuteslist')..' ['..msg.to.title..'] :\n\n'
                local allowed = lang_text(msg.to.id, 'allowed')
                local noAllowed = lang_text(msg.to.id, 'noAllowed')
				local alloweds = lang_text(msg.to.id, 'alloweds')
				local noAlloweds = lang_text(msg.to.id, 'noAlloweds')
                --Enable/disable muteall
                local hash = 'muteall:'..msg.to.id
                if redis:get(hash) then
                    smuteall = noAlloweds
                    smuteallD = ''
                else
                    smuteall = alloweds
                    smuteallD = ''
                end
                text = text..smuteallD..' '..lang_text(msg.to.id, 'muteall')..' > '..smuteall..'\n'
				--Enable/disable send Text
                local hash = 'texts:'..msg.to.id
                if redis:get(hash) then
                    stexts = noAlloweds
                    stextsD = ''
                else
                    stexts = alloweds
                    stextsD = ''
                end
                text = text..stextsD..' '..lang_text(msg.to.id, 'texts')..' > '..stexts..'\n'
				--Enable/disable send photos
                local hash = 'photo:'..msg.to.id
                if redis:get(hash) then
                    sPhoto = noAlloweds
                    sPhotoD = ''
                else
                    sPhoto = alloweds
                    sPhotoD = ''
                end
                text = text..sPhotoD..' '..lang_text(msg.to.id, 'photos')..' > '..sPhoto..'\n'
				--Enable/disable send videos
                local hash = 'video:'..msg.to.id
                if redis:get(hash) then
                    svideo = noAlloweds
                    svideoD = ''
                else
                    svideo = alloweds
                    svideoD = ''
                end
                text = text..svideoD..' '..lang_text(msg.to.id, 'video')..' > '..svideo..'\n'

				--Enable/disable gifs
                local hash = 'gifs:'..msg.to.id
                if redis:get(hash) then
                    sGif = noAlloweds
                    sGifD = ''
                else
                    sGif = alloweds
                    sGifD = ''
                end
                text = text..sGifD..' '..lang_text(msg.to.id, 'gifs')..' > '..sGif..'\n'
                
				--Enable/disable send audios
                local hash = 'audio:'..msg.to.id
                if redis:get(hash) then
                    sAudio = noAlloweds
                    sAudioD = ''
                else
                    sAudio = alloweds
                    sAudioD = ''
                end
                text = text..sAudioD..' '..lang_text(msg.to.id, 'audios')..' > '..sAudio..'\n'

                --Send muteslist to group or supergroup
                if msg.to.type == 'chat' and matches[1]:lower() == 'muteslist' then
                    reply_msg(msg.id, text, ok_cb, false)
                elseif msg.to.type == 'channel' and matches[1]:lower() == 'muteslist' then
                    reply_msg(msg.id, text, ok_cb, false)
            end
		end
	end
end
		chat_id = msg.to.id
		user_id = msg.from.id
	if matches[1]:lower() == 'gadmins' then
		if permissions(user_id, chat_id, "admins") then
		  	-- Check users id in config
		  	local text = ' '..lang_text(msg.to.id, 'adminList')..':\n'
		  	local compare = text
		  	for v,user in pairs(_config.admin_users) do
			    text = text..' '..user[2]..'\n'
		  	end
		  	if compare == text then
		  		text = text..' '..lang_text(chat_id, 'adminEmpty')
		  	end
		  	return text
		else
			return
		end
	end
	if matches[1]:lower() == 'addadmin' then
			if permissions(user_id, chat_id, "rank_admin") then
				if msg.reply_id then
					get_message(msg.reply_id, admin_by_reply, false)
				end
				if is_id(matches[2]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[2]
					user_info('user#id'..user_id, set_admin, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[2], '@', '')
	            	resolve_username(member, admin_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return
			end
		end
		if matches[1]:lower() == 'setowner' then
			if permissions(user_id, chat_id, "rank_owner") then
				if msg.reply_id then
					get_message(msg.reply_id, owner_by_reply, false)
				end
				if is_id(matches[2]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[2]
					user_info('user#id'..user_id, set_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[2], '@', '')
	            	resolve_username(member, owner_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return
			end
		end
		if matches[1]:lower() == 'promote' then
			if permissions(user_id, chat_id, "rank_md") then
				if msg.reply_id then
					get_message(msg.reply_id, mod_by_reply, false)
				end
				if is_id(matches[2]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[2]
					user_info('user#id'..user_id, set_mod, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[2], '@', '')
	            	resolve_username(member, mod_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return
			end
		end
		if matches[1]:lower() == 'demote' then
			if permissions(user_id, chat_id, "rank_md") then
				if msg.reply_id then
					get_message(msg.reply_id, guest_by_reply, false)
				end
				if is_id(matches[2]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[2]
					user_info('user#id'..user_id, set_guest, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[2], '@', '')
	            	resolve_username(member, guest_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return
			end
		end
		if matches[1]:lower() == 'remadmin' then
			if permissions(user_id, chat_id, "rank_owner") then
				if msg.reply_id then
					get_message(msg.reply_id, rmvadmin_by_reply, false)
				end
				if is_id(matches[2]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[2]
					user_info('user#id'..user_id, rmv_admin, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[2], '@', '')
	            	resolve_username(member, rmvadmin_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return
			end
		end
		if matches[1]:lower() == 'demowner' then
			if permissions(user_id, chat_id, "rank_owner") then
				if msg.reply_id then
					get_message(msg.reply_id, demowner_by_reply, false)
				end
				if is_id(matches[2]) then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = matches[2]
					user_info('user#id'..user_id, dem_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[2], '@', '')
	            	resolve_username(member, demowner_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return
			end
		end
    if matches[1]:lower() == 'rules' then
      	return ret_rules_channel(msg)
    elseif matches[1]:lower() == 'setrules' then
    	if permissions(msg.from.id, msg.to.id, 'rules') then
    		set_rules_channel(msg, matches[2])
    		return reply_msg(msg.id,lang_text(msg.to.id, 'setRules'),ok_cb,false)
    	end
	end
	if matches[1]:lower() == 'reset' and matches[2]:lower() == 'group' then
	if permissions(user_id, chat_id, "rank_md") then
	local hashlink = 'link:'..msg.to.id
    local hashwlc = 'welcome:'..msg.to.id
	local hashcmd = 'cmds:'..msg.to.id
	local hashban =  'banned:'..chat_id
	local hashmute = 'muted:'..msg.to.id..':'
	local hashst = 'maxchar:'..msg.to.id
	local hashmod = 'mod:'..msg.to.id
	local hashfilter = get_variables_hash(msg)
    local hashstick = 'stickers:'..msg.to.id
    local hashtaghash = 'tag:'..msg.to.id
    local hashlinks = 'links:'..msg.to.id
    local hashwebp = 'webpage:'..msg.to.id
	local hashhashtag = 'hashtag:'..msg.to.id
    local hashtg = 'tgservices:'..msg.to.id
    local hashemoji = 'emoji:'..msg.to.id
    local hashcontact = 'contact:'..msg.to.id
    local hasheng = 'english:'..msg.to.id
    local hashar = 'arabic:'..msg.to.id
    local hashfwd = 'forward:'..msg.to.id
    local hashreply = 'reply:'..msg.to.id
    local hashbadw = 'badword:'..msg.to.id
    local hashbots = 'antibot:'..msg.to.id
    local hashkickme = 'kickme:'..msg.to.id
    local hashspam = 'spam:'..msg.to.id
    local hashmember = 'lockmember:'..msg.to.id
    local hashphotoset = 'setphoto:'..msg.to.id
    local hashsetname = 'name:enabled:'..msg.to.id
    local hashlang = 'langset:'..msg.to.id
    local hashflood = 'anti-flood:'..msg.to.id
    local hashfloodmax = 'flood:max:'..msg.to.id
    local hashfloodtime = 'flood:time:'..msg.to.id
    local hashmuteall = 'muteall:'..msg.to.id
    local hashtextmute = 'texts:'..msg.to.id
    local hashphotomute = 'photo:'..msg.to.id
    local hashvideomute = 'video:'..msg.to.id
    local hashgifmute = 'gifs:'..msg.to.id
    local hashaudiomute = 'audio:'..msg.to.id
	del_rules_channel(msg.to.id)
	redis:del(hashlink)
	redis:del(hashban)
	redis:del(hashst)
	redis:del(hashwlc)
	redis:del(hashcmd)
	redis:del(hashmute)
	redis:del(hashmod)
    redis:del(hashfilter, var_name)
	redis:del(hashstick)
	redis:del(hashtaghash)
	redis:del(hashlinks)
	redis:del(hashwebp)
	redis:del(hashhashtag)
	redis:del(hashtg)
	redis:del(hashemoji)
	redis:del(hashcontact)
	redis:del(hasheng)
	redis:del(hashar)
	redis:del(hashfwd)
	redis:del(hashreply)
	redis:del(hashbadw)
	redis:del(hashbots)
	redis:del(hashkickme)
	redis:del(hashspam)
	redis:del(hashmember)
	redis:del(hashphotoset)
	redis:del(hashsetname)
	redis:del(hashlang)
	redis:del(hashflood)
	redis:del(hashfloodmax)
	redis:del(hashfloodtime)
	redis:del(hashmuteall)
	redis:del(hashtextmute)
	redis:del(hashphotomute)
	redis:del(hashvideomute)
	redis:del(hashgifmute)
	redis:del(hashaudiomute)
    return reply_msg(msg.id,lang_text(msg.to.id, 'resetgp'),ok_cb,false)
	end
end
    if matches[1]:lower() == 'clean' then
      if permissions(msg.from.id, msg.to.id, 'rules') then
		if matches[2]:lower() == 'rules' then
    		del_rules_channel(msg.to.id)
    		return reply_msg(msg.id,lang_text(msg.to.id, 'remRules'),ok_cb,false)
    end
		if matches[2]:lower() == 'link' then
		    hash = 'link:'..msg.to.id
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remLink'),ok_cb,false)
    end
	if matches[2]:lower() == 'cmds' then
		    hash = 'chat:'..msg.to.id..':variables'
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remGpcmds'),ok_cb,false)
    end
	if matches[2]:lower() == 'gcmds' and is_sudo(msg) then
		    hash = 'g:variables'
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remGcmds'),ok_cb,false)
    end
		if matches[2]:lower() == 'welcome' then
		    hash = 'welcome:'..msg.to.id
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remWlc'),ok_cb,false)
    end
		if matches[2]:lower() == 'banlist' then
	        local hash =  'banned:'..msg.to.id
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remBanlist'),ok_cb,false)
	end
		if matches[2]:lower() == 'gbanlist' and is_sudo(msg) then
	        local hash =  'gban:'
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remGbanlist'),ok_cb,false)
	end
		if matches[2]:lower() == 'gmutelist' and is_sudo(msg) then
	        local hash =  'gmuted:'
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remGmutelist'),ok_cb,false)
	end
		if matches[2]:lower() == 'deleted' and permissions(msg.from.id, msg.to.id, 'bot') then
	        local receiver = get_receiver(msg) 
			channel_get_users(receiver, check_member_super_deleted,{receiver = receiver, msg = msg})
		return
	end
		if matches[2]:lower() == 'mutelist' then
	        local hash = 'muted:'..msg.to.id
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remMutelist'),ok_cb,false)
	end
		if matches[2]:lower() == 'modlist' and permissions(msg.from.id, msg.to.id, "setlink") then
	        local hash = 'mod:'..msg.to.id
			redis:del(hash)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remModlist'),ok_cb,false)
	end
		if matches[2]:lower() == 'filterlist' then
            local hash = get_variables_hash(msg)
            redis:del(hash, var_name)
		return reply_msg(msg.id,lang_text(msg.to.id, 'remFilterlist'),ok_cb,false)
	end
  end
end
    if matches[1]:lower() == 'del' and not matches[2] then
        if permissions(msg.from.id, msg.to.id, "settings") then
            if msg.reply_id then
                get_message(msg.reply_id, remove_message, false)
                get_message(msg.id, remove_message, false)
            end
            return
        else
            return
        end
	end
    if matches[1]:lower() == 'del' and matches[2] then
        --if permissions(msg.from.id, msg.to.id, "help") then
		if is_sudo(msg) then
            if msg.to.type == 'channel' then
	            if permissions(msg.from.id, msg.to.id, "help") then
                    if tonumber(matches[2]) > 100 or tonumber(matches[2]) < 2 then
                    return reply_msg(msg.id,"*Wrong number,range is [2-99]",ok_cb,false)
                    end
                end
            get_history(msg.to.peer_id, matches[2] + 1 , history , {chatid = msg.to.peer_id, con = matches[2]})
	    else
        return
                end
       else
        return
        end
    end
	    local receiver = get_receiver(msg)
        local chat = msg.to.id
    if matches[1]:lower() == "id" and not msg.reply_id and not matches[2] then
	--[[local user_id = msg.from.id
    local chat_id = get_receiver(msg)
    local token = "249248482:AAGoAukjbuwzYCIo6kDQOti5aPtHNeTjl58"
    local db = 'https://api.telegram.org/bot'..token..'/getUserProfilePhotos?user_id='..user_id
    local path = 'https://api.telegram.org/bot'..token..'/getFile?file_id='
    local img = 'https://api.telegram.org/file/bot'..token..'/'
    local res, code = https.request(db)
    local jdat = json:decode(res)
    local fileid = ''
    local count = jdat.result.total_count
	local bot = '249248482'
	if jdat.result.total_count == 0 then
      send_photo(chat_id,photos,ok_cb,false)
         else
    fileid = jdat.result.photos[1][3].file_id
    end
    if tonumber(count) == 0 then
	local photos = '/root/blackplus/not.jpg'
	local texts = lang_text(chat, 'supergroup')..': '..msg.to.id..'\n'..lang_text(chat, 'idusername')..': @'..(msg.from.username or '')..'\n'..lang_text(chat, 'idphonenumber')..': +'..(msg.from.phone or '404 Not Found!')..'\n'..lang_text(chat, 'iduserlink')..': Telegram.Me/'..(msg.from.username or '')..'\n'..lang_text(chat, 'user')..': '..msg.from.id..'\n'..lang_text(chat, 'nopt')
      send_photo2(chat_id,photos,texts,ok_cb,false)
         else
    local pt, code = https.request(path..fileid)
    local jdat2 = json:decode(pt)
    local path2 = jdat2.result.file_path
    local link = img..path2
    local photo = download_to_file(link,"ax.jpg")
	local text = lang_text(chat, 'supergroup')..': '..msg.to.id..'\n'..lang_text(chat, 'idusername')..': @'..(msg.from.username or '')..'\n'..lang_text(chat, 'idphonenumber')..': +'..(msg.from.phone or '404 Not Found!')..'\n'..lang_text(chat, 'iduserlink')..': Telegram.Me/'..(msg.from.username or '')..'\n'..lang_text(chat, 'user')..': '..msg.from.id..'\n'..lang_text(chat, 'phts')..': '..jdat.result.total_count
       send_photo2(chat_id,photo,text,ok_cb,false)
end	]]
    if msg.to.type == 'channel' or msg.to.type == 'chat' then
	local hash =  'info'..msg.from.id
    local hashnumb = redis:get(hash)
	local hashs = 'mymsgs:'..msg.from.id..':'..msg.to.id
    local msgs = redis:get(hashs)
	if msg.from.username then
                reply_msg(msg.id, lang_text(chat, 'supergroup')..': <code>'..msg.to.id..'</code>\n'..lang_text(chat, 'idusername')..': <a href="https://telegram.me/'..(msg.from.username)..'">'..'@'..(msg.from.username)..'</a>\n'..lang_text(chat, 'umsg')..': <code>'..msgs..'</code>\n'..lang_text(chat, 'user')..': <code>'..msg.from.id..'</code>', ok_cb, false)
   else                                                                                                                              
                reply_msg(msg.id, lang_text(chat, 'supergroup')..': <code>'..msg.to.id..'</code>\n'..lang_text(chat, 'umsg')..': <code>'..msgs..'</code>\n'..lang_text(chat, 'user')..': <code>'..msg.from.id..'</code>', ok_cb, false)
   end
   end
    elseif matches[1]:lower() == 'id' and msg.reply_id and not matches[2] then
            chat_type = msg.to.type
            chat_id = msg.to.id
            if msg.reply_id then
                get_message(msg.reply_id, get_id_who, {receiver=get_receiver(msg)})
                return
            end
            if is_id(matches[2]) then
                print(1)
                user_info('user#id'..matches[2], whoisid, {chat_type=chat_type, chat_id=chat_id, user_id=matches[2]})
                return
    else
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, whoisname, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            end
    elseif matches[1]:lower() == 'id' and matches[2] then
            chat_type = msg.to.type
            chat_id = msg.to.id
            if msg.reply_id then
                get_message(msg.reply_id, get_id_who, {receiver=get_receiver(msg)})
                return
            end
            if is_id(matches[2]) then
                print(1)
                user_info('user#id'..matches[2], whoisid, {chat_type=chat_type, chat_id=chat_id, user_id=matches[2]})
                return
    else
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, whoisname, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
         end
    elseif matches[1]:lower() == "gid" and msg.to.type == 'channel' and not msg.service then
	    if permissions(user_id, chat_id, "link") then
                reply_msg(msg.id, '<code>9678155681 6324781252 4364915821 '..msg.to.id..'</code>', ok_cb, false)
	else
		        reply_msg(msg.id, lang_text(msg.to.id,'owneronlygid'), ok_cb, false)
		end
		if matches[1]:lower() == "gid" and msg.to.type == 'chat' and permissions(user_id, chat_id, "link") then
		reply_msg(msg.id, lang_text(msg.to.id,'notwkinchat'), ok_cb, false)
        end
end
	if matches[1] == "9678155681" and matches[2] == '6324781252' and matches[3] == '4364915821' and permissions(user_id, chat_id, "rank_owner") and msg.fwd_from and matches[4] and msg.to.type == 'channel' then
	    if msg.fwd_from.peer_id == tonumber(bot_id) then
                text = lang_text(msg.to.id, 'sSettings')..' ['..matches[4]..'] :\n\n'
                local allowed = lang_text(msg.to.id, 'allowed')
                local noAllowed = lang_text(msg.to.id, 'noAllowed')
                local le = lang_text(msg.to.id, 'le')
                local ld = lang_text(msg.to.id, 'ld')
				
				--Enable/disable Group Welcome
                local hash = 'wlstat:'..matches[4]
                if redis:get(hash) then
                    sgpwlc = le
                    sgpwlcD = ''
                else
                    sgpwlc = ld
                    sgpwlcD = ''
                end
                text = text..sgpwlcD..' '..lang_text(msg.to.id, 'gpwlc')..' > '..sgpwlc..'\n'
				
				local hash = 'cmds:'..msg.to.id
                if redis:get(hash) then
                    scmds = ld
                    scmdsD = ''
                else
                    scmds = le
                    scmdsD = ''
                end
                text = text..scmdsD..' '..lang_text(msg.to.id, 'cmds')..' > '..scmds..'\n'
                --Enable/disable Stickers
                local hash = 'stickers:'..matches[4]
                if redis:get(hash) then
                    sStickers = noAllowed
                    sStickersD = ''
                else
                    sStickers = allowed
                    sStickersD = ''
                end
                text = text..sStickersD..' '..lang_text(msg.to.id, 'stickers')..' > '..sStickers..'\n'

		        --Enable/disable Tgservices
                local hash = 'tgservices:'..matches[4]
                if redis:get(hash) then
                    tTgservices = noAllowed
                    tTgservicesD = ''
                else
                    tTgservices = allowed
                    tTgservicesD = ''
                end
                text = text..tTgservicesD..' '..lang_text(msg.to.id, 'tgservices')..' > '..tTgservices..'\n'

                --Enable/disable Links
                local hash = 'links:'..matches[4]
                if redis:get(hash) then
                    sLink = noAllowed
                    sLinkD = ''
                else
                    sLink = allowed
                    sLinkD = ''
                end
                text = text..sLinkD..' '..lang_text(msg.to.id, 'links')..' > '..sLink..'\n'

				--Enable/disable webpage
                local hash = 'webpage:'..matches[4]
                if redis:get(hash) then
                    swebpage = noAllowed
                    swebpageD = ''
                else
                    swebpage = allowed
                    swebpageD = ''
                end
                text = text..swebpageD..' '..lang_text(msg.to.id, 'webpage')..' > '..swebpage..'\n'
				
                --Enable/disable Tag
                local hash = 'tag:'..matches[4]
                if redis:get(hash) then
                    sTag = noAllowed
                    sTagD = ''
                else
                    sTag = allowed
                    sTagD = ''
                end
                text = text..sTagD..' '..lang_text(msg.to.id, 'tag')..' > '..sTag..'\n'
				
				--Enable/disable hashtag
				local hash = 'hashtag:'..matches[4]
                if redis:get(hash) then
                    shashtag = noAllowed
                    shashtagD = ''
                else
                    shashtag = allowed
                    shashtagD = ''
                end
                text = text..shashtagD..' '..lang_text(msg.to.id, 'hashtag')..' > '..shashtag..'\n'
				
				--Enable/disable emoji
                local hash = 'emoji:'..matches[4]
                if redis:get(hash) then
                    semoji = noAllowed
                    semojiD = ''
                else
                    semoji = allowed
                    semojiD = ''
                end
                text = text..semojiD..' '..lang_text(msg.to.id, 'emoji')..' > '..semoji..'\n'
				
				--Enable/disable contacts
                local hash = 'contact:'..matches[4]
                if redis:get(hash) then
                    scontact = noAllowed
                    scontactD = ''
                else
                    scontact = allowed
                    scontactD = ''
                end
                text = text..scontactD..' '..lang_text(msg.to.id, 'contact')..' > '..scontact..'\n'
				
				--Enable/disable english
                local hash = 'english:'..matches[4]
                if redis:get(hash) then
                    senglish = noAllowed
                    senglishD = ''
                else
                    senglish = allowed
                    senglishD = ''
                end
                text = text..senglishD..' '..lang_text(msg.to.id, 'english')..' > '..senglish..'\n'
				
			    --Enable/disable arabic messages
                local hash = 'arabic:'..matches[4]
                if not redis:get(hash) then
                    sArabe = allowed
                    sArabeD = ''              
                else
                    sArabe = noAllowed
                    sArabeD = ''
                end
                text = text..sArabeD..' '..lang_text(msg.to.id, 'arabic')..' > '..sArabe..'\n'

				--Enable/disable forward
                local hash = 'forward:'..matches[4]
                if redis:get(hash) then
                    sforward = noAllowed
                    sforwardD = ''
                else
                    sforward = allowed
                    sforwardD = ''
                end
                text = text..sforwardD..' '..lang_text(msg.to.id, 'forward')..' > '..sforward..'\n'
				
				--Enable/disable reply
                local hash = 'reply:'..matches[4]
                if redis:get(hash) then
                    sreply = noAllowed
                    sreplyD = ''
                else
                    sreply = allowed
                    sreplyD = ''
                end
                text = text..sreplyD..' '..lang_text(msg.to.id, 'reply')..' > '..sreply..'\n'
				
				--Enable/disable badword
                local hash = 'badword:'..matches[4]
                if redis:get(hash) then
                    sbadword = noAllowed
                    sbadwordD = ''
                else
                    sbadword = allowed
                    sbadwordD = ''
                end
                text = text..sbadwordD..' '..lang_text(msg.to.id, 'badword')..' > '..sbadword..'\n'
				
                --Enable/disable bots
                local hash = 'antibot:'..matches[4]
                if not redis:get(hash) then
                    sBots = allowed
                    sBotsD = ''
                else
                    sBots = noAllowed
                    sBotsD = ''
                end
                text = text..sBotsD..' '..lang_text(msg.to.id, 'bots')..' > '..sBots..'\n'
                
                --Enable/disable kickme
                local hash = 'kickme:'..matches[4]
                if redis:get(hash) then
                    sKickme = allowed
                    sKickmeD = ''
                else
                    sKickme = noAllowed
                    sKickmeD = ''
                end
                text = text..sKickmeD..' '..lang_text(msg.to.id, 'kickme')..' > '..sKickme..'\n'

                --Enable/disable spam
                local hash = 'spam:'..matches[4]
                if redis:get(hash) then
                    sSpam = noAllowed
                    sSpamD = ''
                else
                    sSpam = allowed
                    sSpamD = ''
                end
                text = text..sSpamD..' '..lang_text(msg.to.id, 'spam')..' > '..sSpam..'\n'

				--Lock/unlock numbers of channel members
                local hash = 'lockmember:'..matches[4]
                if redis:get(hash) then
                    sLock = noAllowed
                    sLockD = ''
                else
                    sLock = allowed
                    sLockD = ''
                end
                text = text..sLockD..' '..lang_text(msg.to.id, 'lockmmr')..' > '..sLock..'\n'
                --Enable/disable setphoto
                local hash = 'setphoto:'..matches[4]
                if not redis:get(hash) then
                    sSPhoto = allowed
                    sSPhotoD = ''
                else
                    sSPhoto = noAllowed
                    sSPhotoD = ''
                end
                text = text..sSPhotoD..' '..lang_text(msg.to.id, 'setphoto')..' > '..sSPhoto..'\n'

                --Enable/disable changing group name
                local hash = 'name:enabled:'..matches[4]
                if redis:get(hash) then
                    sName = noAllowed
                    sNameD = ''
                else
                    sName = allowed
                    sNameD = ''
                end
                text = text..sNameD..' '..lang_text(msg.to.id, 'gName')..' > '..sName..'\n'

                local hash = 'langset:'..matches[4]
                if redis:get(hash) then
                    sLang = redis:get(hash)
                    sLangD = ''
                else
                    sLang = lang_text(msg.to.id, 'noSet')
                    sLangD = ''
                end
                text = text..sLangD..' '..lang_text(msg.to.id, 'language')..' > '..string.upper(sLang)..'\n'
               
			   --Enable/disable Flood
                local hash = 'anti-flood:'..matches[4]
                if redis:get(hash) then
                    sFlood = allowed
                    sFloodD = ''
                else
                    sFlood = noAllowed
                    sFloodD = ''
                end
                text = text..sFloodD..' '..lang_text(msg.to.id, 'flood')..' > '..sFlood..'\n'

                local hash = 'flood:max:'..matches[4]
                if not redis:get(hash) then
                    floodMax = 5
                else
                    floodMax = redis:get(hash)
                end

                local hash = 'flood:time:'..matches[4]
                if not redis:get(hash) then
                    floodTime = 3
                else
                    floodTime = redis:get(hash)
                end

               	text = text..' '..lang_text(msg.to.id, 'mFlood')..' > '..floodMax..'\n '..lang_text(msg.to.id, 'tFlood')..' > '..floodTime..'\n______________________\nMutes List:\n\n'            
               
			    --Enable/disable muteall
                local hash = 'muteall:'..matches[4]
                if redis:get(hash) then
                    smuteall = noAllowed
                    smuteallD = ''
                else
                    smuteall = allowed
                    smuteallD = ''
                end
                text = text..smuteallD..' '..lang_text(msg.to.id, 'muteall')..' > '..smuteall..'\n'
				--Enable/disable send Text
                local hash = 'texts:'..matches[4]
                if redis:get(hash) then
                    stexts = noAllowed
                    stextsD = ''
                else
                    stexts = allowed
                    stextsD = ''
                end
                text = text..stextsD..' '..lang_text(msg.to.id, 'texts')..' > '..stexts..'\n'
				--Enable/disable send photos
                local hash = 'photo:'..matches[4]
                if redis:get(hash) then
                    sPhoto = noAllowed
                    sPhotoD = ''
                else
                    sPhoto = allowed
                    sPhotoD = ''
                end
                text = text..sPhotoD..' '..lang_text(msg.to.id, 'photos')..' > '..sPhoto..'\n'
				--Enable/disable send videos
                local hash = 'video:'..matches[4]
                if redis:get(hash) then
                    svideo = noAllowed
                    svideoD = ''
                else
                    svideo = allowed
                    svideoD = ''
                end
                text = text..svideoD..' '..lang_text(msg.to.id, 'video')..' > '..svideo..'\n'

				--Enable/disable gifs
                local hash = 'gifs:'..matches[4]
                if redis:get(hash) then
                    sGif = noAllowed
                    sGifD = ''
                else
                    sGif = allowed
                    sGifD = ''
                end
                text = text..sGifD..' '..lang_text(msg.to.id, 'gifs')..' > '..sGif..'\n'
                
				--Enable/disable send audios
                local hash = 'audio:'..matches[4]
                if redis:get(hash) then
                    sAudio = noAllowed
                    sAudioD = ''
                else
                    sAudio = allowed
                    sAudioD = ''
                end
                text = text..sAudioD..' '..lang_text(msg.to.id, 'audios')..' > '..sAudio..'\n'

	    hash = 'link:'..matches[4]
         local linktext = redis:get(hash)
  	      local hashw = 'channel:id:'..matches[4]..':rules'
            reply_msg(msg.id, 'Group Info:\n\n> Gp Link: '..(linktext or 'Link Not Found D:')..'\n> Group Id: '..matches[4]..'\n> Group rules: '..(redis:get(hashw) or 'Rules was #Not Setet.')..'\n__________________\nGroup Settings :\n\n'..text..'\n\n <code>Channel id</code> > @Black_Ch ', ok_cb, false)
		else
	reply_msg(msg.id,lang_text(msg.to.id, 'notfwdfromblackplus'),ok_cb,false)
   end
end
    if matches[1]:lower() == 'setlang' then
        if permissions(msg.from.id, msg.to.id, "set_lang") then
            hash = 'langset:'..msg.to.id
            redis:set(hash, matches[2])
             reply_msg(msg.id,lang_text(msg.to.id, 'langUpdated')..string.upper(matches[2]), ok_cb, true)
        else
            return
        end
	end
    if matches[1]:lower() == 'setcmd' then
        if is_sudo(msg) then
            hash = 'cmdset:'..msg.to.id
            redis:set(hash, matches[2])
             reply_msg(msg.id,'done', ok_cb, true)
        else
            return
        end
	end
    if matches[1]:lower() == 'setname' then
        if permissions(msg.from.id, msg.to.id, "settings") then
            local hash = 'name:enabled:'..msg.to.id
            if not redis:get(hash) then
                if msg.to.type == 'chat' then
                    rename_chat(msg.to.peer_id, matches[2], ok_cb, false)
                elseif msg.to.type == 'channel' then
                    rename_channel(msg.to.peer_id, matches[2], ok_cb, false)
                end
            end
            return
        else
            return
        end
	end
	if matches[1]:lower() == "info" and permissions(user_id, chat_id, "rank_md") then
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
	end
		if matches[1]:lower() == "admins" and permissions(user_id, chat_id, "rank_md") then
			member_type = 'Admins'
			rlpy = msg.id
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, rlpy = rlpy, member_type = member_type})
		end
    if matches[1]:lower() == 'newlink' then
        if permissions(msg.from.id, msg.to.id, "setlink") then
        	local receiver = get_receiver(msg)
            local hash = 'link:'..msg.to.id
    		local function cb(extra, success, result)
    			if result then
    				redis:set(hash, result)
    			end
	            if success == 0 then
	                return send_large_msg(receiver, '*Err\nNot #Creator!!', ok_cb, true)
	            end
    		end
    		if msg.to.type == 'chat' then
                result = export_chat_link(receiver, cb, true)
            elseif msg.to.type == 'channel' then
                result = export_channel_link(receiver, cb, true)
            end
    		if result then
	            if msg.to.type == 'chat' then
	                reply_msg(msg.id, ' '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
	            elseif msg.to.type == 'channel' then
	                reply_msg(msg.id, ' '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
	            end
	        end
            return
        else
            return
        end
	end
    if matches[1]:lower() == 'setlink' and matches[2] then
        if permissions(msg.from.id, msg.to.id, "setlink") then
            hash = 'link:'..msg.to.id
            redis:set(hash, matches[2])
            if msg.to.type == 'chat' then
                reply_msg(msg.id, ' '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
            elseif msg.to.type == 'channel' then
                reply_msg(msg.id, ' '..lang_text(msg.to.id, 'linkSaved'), ok_cb, true)
            end
            return
        else
            return
        end
	end
   if matches[1]:lower() == "setlink" and not matches[2] then
	if permissions(msg.from.id, msg.to.id, "setlink") then
            redis:set("link:"..msg.to.id, 'Waiting For Link!\nPls Send Group Link.\n\nJoin My Channel > @Black_Ch')
            return reply_msg(msg.id,lang_text(msg.to.id, 'plssendlink'),ok_cb,false)
    end
   end
	if msg.text then
	  if permissions(msg.from.id, msg.to.id, "setlink") then
	    if msg.text:match("(https://telegram.me/joinchat/%S+)") then
	     local hash1 = "link:"..msg.to.id
	        if redis:get(hash1) == 'Waiting For Link!\nPls Send Group Link.\n\nJoin My Channel > @Black_Ch' then
         local glink = msg.text:match("(https://telegram.me/joinchat/%S+)")
         local hash = "link:"..msg.to.id
               redis:set(hash,glink)
             return reply_msg(msg.id,lang_text(msg.to.id, 'linkSaved'),ok_cb,false)

        end
      end
   end
end
    if matches[1]:lower() == 'linksp' then
            hash = 'link:1031459611'
            local linksp = redis:get(hash)
            if linksp then
                    reply_msg(msg.id,'<a href="'..linksp..'">'..(lang_text(msg.to.id, 'linksp'))..'</a>', ok_cb, true)
            else
                    reply_msg(msg.id, lang_text(msg.to.id, 'nolinksp'), ok_cb, true)
        end
	end
    if matches[1]:lower() == 'link' and lang == 'en' or matches[1] == 'لینک' and lang == 'fa' and not matches[2] then
        if permissions(msg.from.id, msg.to.id, "link") then
            hash = 'link:'..msg.to.id
            local linktext = redis:get(hash)
            if linktext and linktext ~= 'Waiting For Link!\nPls Send Group Link.\n\nJoin My Channel > @Black_Ch' then
                if msg.to.type == 'chat' then
                    reply_msg(msg.id, ' '..lang_text(msg.to.id, 'groupLink')..':\n'..linktext, ok_cb, true)
                elseif msg.to.type == 'channel' then
                    reply_msg(msg.id, ' '..lang_text(msg.to.id, 'sGroupLink')..':\n'..linktext, ok_cb, true)
                end
            else
                if msg.to.type == 'chat' then
                    reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noLinkSet'), ok_cb, true)
                elseif msg.to.type == 'channel' then
                    reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noLinkSet'), ok_cb, true)
                end
            end
            return
        else
            return
        end
	end
    if matches[1]:lower() == 'search' and matches[2]:lower() == 'groups' then
        if permissions(msg.from.id, msg.to.id, "rank_owner") then
		    local gpuser = matches[3]
            hash = 'link:'..gpuser
            local linktext = redis:get(hash)
            if linktext then
                    reply_msg(msg.id, ' '..lang_text(msg.to.id, 'gpdetected')..' '..linktext, ok_cb, true)
            else
                    reply_msg(msg.id, '#Error\nGroup <b>Not Found</b> Or <b>No Link Set</b> For This Group:(', ok_cb, true)
                end
            end
        end
	if matches[1]:lower() == 'link' and matches[2]:lower() == 'pv' then
        if permissions(msg.from.id, msg.to.id, "link") then
            hash = 'link:'..msg.to.id
            local linktext = redis:get(hash)
            if linktext then
                    reply_msg(msg.id, ' '..lang_text(msg.to.id, 'linkpvsend'), ok_cb, true)
					send_large_msg('user#id'..msg.from.id, lang_text(msg.to.id, 'gplinkonpv')..':\n'..linktext, ok_cb, false)
            else
                    reply_msg(msg.id, ' '..lang_text(msg.to.id, 'noLinkSet'), ok_cb, true)	
            end
        end
    end
if matches[1]:lower() == 'version' or matches[1]:lower() == 'black' or matches[1]:lower() == 'blackplus' then
      reply_msg(msg.id,' <b>B L A C K +</b>\n<i>|A New Bot For Manage Your SuperGroups.|</i>\n\n\n<b>> Developer: </b> > @MehdiHS\n> <b>Channel</b> @Black_Ch\n> <i>Bot version</i>  : <b>7.9</b>\n> <b>Support Team</b> : @BlackSupport_Bot',ok_cb,false)
end
if matches[1]:lower() == 'echo'  then  
  return reply_msg(msg.id,'<b>Your Text:</b>\n_____________\n\n'..matches[2],ok_cb,false)
end
    if matches[1]:lower() == 'ping' then 
         reply_msg(msg.id,'<code>Pong!</code>',ok_cb,false)
    end
    if matches[1]:lower() == 'ban' then
        if permissions(msg.from.id, msg.to.id, "ban") then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                if msg.to.type == 'chat' then
                    get_message(msg.reply_id, chat_ban, false)
                elseif msg.to.type == 'channel' then
                    get_message(msg.reply_id, channel_ban, {receiver=get_receiver(msg)})
                end
                return
            end
            if not is_id(matches[2]) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, ban_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            end
			if is_id(matches[2]) then
				if permissions(matches[2], chat_id, "link") then
				local user_id = matches[2]
				local chat_id = msg.to.id
                   send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotmod'), ok_cb, false)
        else 
		local user_id = matches[2]
		    if chat_type == 'chat' then
                    reply_msg(msg.id, ' '..lang_text(chat_id, 'banUser:1')..' '..user_id..' '..lang_text(chat, 'banUser:2'), ok_cb, false)
                    chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
                elseif chat_type == 'channel' then
                    reply_msg(msg.id, ' '..lang_text(chat_id, 'banUser:1')..' '..user_id..' '..lang_text(chat, 'banUser:2'), ok_cb, false)
                    channel_kick_user('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
                end
                ban_user(user_id, chat_id)
            return
        end
	end
end
    elseif matches[1]:lower() == 'unban' then
        if permissions(msg.from.id, msg.to.id, "unban") then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                if msg.to.type == 'chat' then
                    get_message(msg.reply_id, chat_unban, false)
                elseif msg.to.type == 'channel' then
                    get_message(msg.reply_id, channel_unban, false)
                end
                return
            end
            if not is_id(matches[2]) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, unban_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
			user_id = matches[2]
                local hash =  'banned:'..chat_id
                redis:srem(hash, user_id)
                reply_msg(msg.id, lang_text(chat_id, 'unbanUser:1')..' '..matches[2]..' '..lang_text(chat_id, 'unbanUser:2'), ok_cb, false)
            end
        else
            return
        end
    elseif matches[1]:lower() == 'kick' then
        if permissions(msg.from.id, msg.to.id, "kick") then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            -- Using pattern #kick
            if msg.reply_id then
                get_message(msg.reply_id, chat_kick, false)
                return
            end
            if not is_id(matches[2]) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, kick_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            end
			if is_id(matches[2]) then
				if permissions(matches[2], chat_id, "link") then
				local user_id = matches[2]
				local chat_id = msg.to.id
                   send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotmod'), ok_cb, false)
                else
                if msg.to.type == 'chat' then
                    reply_msg(msg.id, ' '..lang_text(chat_id, 'kickUser:1')..' '..user_id..' '..lang_text(chat_id, 'kickUser:2'), ok_cb, false)
                    chat_del_user('chat#id'..msg.to.id, 'user#id'..matches[2], ok_cb, false)
                elseif msg.to.type == 'channel' then
                    reply_msg(msg.id, ' '..lang_text(chat_id, 'kickUser:1')..' '..user_id..' '..lang_text(chat_id, 'kickUser:2'), ok_cb, false)
                    channel_kick_user('channel#id'..msg.to.id, 'user#id'..matches[2], ok_cb, false)
                end
			   end
                return
            end
        else
            return
        end
    elseif matches[1]:lower() == 'banall' then
        if permissions(msg.from.id, msg.to.id, "gban") then
            chat_id = msg.to.id
            chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, gban_by_reply, false)
                return
            end
            if not is_id(matches[2]) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, gban_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            end
			if is_id(matches[2]) then
				if permissions(matches[2], chat_id, "gban") then
				local user_id = matches[2]
				local chat_id = msg.to.id
                   send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotadmin'), ok_cb, false)
                else
                local user_id = matches[2]
                local hash =  'gban:'
                redis:sadd(hash, user_id)
				local blocklist =  'blocklist:'
                redis:sadd(blocklist, user_id)
				local buser = 'user#id'..matches[2]
		        block_user(buser, callback, false)
                if chat_type == 'chat' then
                    reply_msg(msg.id, ' '..lang_text(chat_id, 'gbanUser:1')..' '..user_id..' '..lang_text(chat_id, 'gbanUser:2'), ok_cb, false)
                    chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, false)
                elseif chat_type == 'channel' then
                    reply_msg(msg.id, ' '..lang_text(chat_id, 'gbanUser:1')..' '..user_id..' '..lang_text(chat_id, 'gbanUser:2'), ok_cb, false)
                    channel_kick_user('channel#id'..chat_id, 'user#id'..user_id, ok_cb, false)
                end
                return
            end
        else
            return
        end
	end
    elseif matches[1]:lower() == 'unbanall' then
        if permissions(msg.from.id, msg.to.id, "ungban") then
        	chat_id = msg.to.id
        	chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, ungban_by_reply, false)
                return
            end
            if not is_id(matches[2]) then
                local chat_type = msg.to.type
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, ungban_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user_id = matches[2]
                local hash =  'gban:'
                redis:srem(hash, user_id)
				local blocklist =  'blocklist:'
                redis:srem(blocklist, user_id)
				unblock_user('user#id'..user_id, callback, false)
				        reply_msg(msg.id, ' '..lang_text(chat, 'ungbanUser:1')..' '..user_id..' '..lang_text(chat, 'ungbanUser:2'), ok_cb,  true)
                return
            end
        else
            return
        end
    elseif matches[1]:lower() == 'muteuser' then   
        if permissions(msg.from.id, msg.to.id, "mute") then
            if msg.reply_id then
                get_message(msg.reply_id, mute_by_reply, false)
                return
            end
            if matches[2] then
                if is_id(matches[2]) then
				if permissions(matches[2], chat_id, "link") then
				local user_id = matches[2]
				local chat_id = msg.to.id
                   send_msg('channel#id'..chat_id,lang_text(chat_id, 'cnotmmod'), ok_cb, false)
                else
                    local user_id = matches[2]
					local chat_id = msg.to.id
					local hash =  'muted:'..msg.to.id
                    redis:sadd(hash, user_id)
                    if msg.to.type == 'chat' then
                        reply_msg(msg.id, ' '..lang_text(chat_id, 'userMuted:1')..' '..matches[2]..' '..lang_text(chat_id, 'userMuted:2'), ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        reply_msg(msg.id, ' '..lang_text(chat_id, 'userMuted:1')..' '..matches[2]..' '..lang_text(chat_id, 'userMuted:2'), ok_cb, true)
                    end
                    return
                end
			end
				if not is_id(matches[2]) then
                    local member = string.gsub(matches[2], '@', '')
                    local chat_id = msg.to.id
                    local chat_type = msg.to.type
                    resolve_username(member, mute_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                    return
                end
            end
        else
            return
        end
    elseif matches[1]:lower() == 'unmuteuser' then
        if permissions(msg.from.id, msg.to.id, "unmute") then
            if msg.reply_id then
                get_message(msg.reply_id, unmute_by_reply, false)
                return
            end
            if matches[2] then
                if is_id(matches[2]) then
                    local hash =  'muted:'..msg.to.id
					local user_id = matches[2]
                    redis:srem(hash, user_id)
                    if msg.to.type == 'chat' then
                        reply_msg(msg.id, ' '..lang_text(chat_id, 'userUnmuted:1')..' '..matches[2]..' '..lang_text(chat_id, 'userUnmuted:2'), ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        reply_msg(msg.id, ' '..lang_text(chat_id, 'userUnmuted:1')..' '..matches[2]..' '..lang_text(chat_id, 'userUnmuted:2'), ok_cb, true)
                    end
                    return
                else
                    local member = string.gsub(matches[2], '@', '')
                    local chat_id = msg.to.id
                    local chat_type = msg.to.type
                    resolve_username(member, unmute_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                    return
                end
            end
        else
            return
        end
    elseif matches[1]:lower() == 'gmuteuser' then   
        if permissions(msg.from.id, msg.to.id, "rank_admin") then
            if msg.reply_id and is_sudo(msg) then
                get_message(msg.reply_id, gmute_by_reply, false)
                return
            end
            if matches[2] then
                if is_id(matches[2]) then
                    local user_id = matches[2]
					local hash =  'gmuted:'
                    redis:sadd(hash, user_id)
                    if msg.to.type == 'chat' then
                        reply_msg(msg.id, ' کاربر در تمامی گروه های ربات میوت شد', ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        reply_msg(msg.id, ' کاربر در تمامی گروه های ربات میوت شد', ok_cb, true)
                    end
                    return
                else
                    local member = string.gsub(matches[2], '@', '')
                    local chat_id = msg.to.id
                    local chat_type = msg.to.type
                    resolve_username(member, gmute_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                    return
                end
            end
        else
            return
        end
    elseif matches[1]:lower() == 'gunmuteuser' then
        if permissions(msg.from.id, msg.to.id, "rank_admin") then
            if msg.reply_id then
                get_message(msg.reply_id, gunmute_by_reply, false)
                return
            end
            if matches[2] then
                if is_id(matches[2]) then
                    local hash =  'gmuted:'
					local user_id = matches[2]
                    redis:srem(hash, user_id)
                    if msg.to.type == 'chat' then
                        reply_msg(msg.id, ' کاربر در تمامی گروه های ربات آنمیوت شد', ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        reply_msg(msg.id, ' کاربر در تمامی گروه های ربات آنمیوت شد', ok_cb, true)
                    end
                    return
                else
                    local member = string.gsub(matches[2], '@', '')
                    local chat_id = msg.to.id
                    local chat_type = msg.to.type
                    resolve_username(member, gunmute_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                    return
                end
            end
        else
            return
        end
    elseif matches[1]:lower() == 'kickme' then
        local hash = 'kickme:'..msg.to.id
        if redis:get(hash) then
            if msg.to.type == 'chat' then
                reply_msg(msg.id, ' '..lang_text(chat_id, 'kickmeBye')..' @'..msg.from.username..' ('..msg.from.id..').', ok_cb, true)
                chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, false)
            elseif msg.to.type == 'channel' then
                reply_msg(msg.id, ' '..lang_text(chat_id, 'kickmeBye')..' @'..msg.from.username..' ('..msg.from.id..').', ok_cb, true)
                channel_kick_user('channel#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, false)
        end  
    end
end
    if matches[1]:lower() == 'inv' or matches[1]:lower() == 'invite' then
        if is_sudo(msg) then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                    get_message(msg.reply_id, inv_by_reply, {receiver=get_receiver(msg)})
                return
            end
            if not dgt_id(matches[2]) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, inv_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                user_id = matches[2]
                channel_invite_user("channel#id"..chat_id, 'user#id'..user_id, ok_cb, false)
                return
            end
        else
            return
        end
	end
    if matches[1]:lower() == 'setphoto' then
        if permissions(msg.from.id, msg.to.id, "settings") then
            hash = 'setphoto:'..msg.to.id
            if redis:get(hash) then
                if matches[2] == 'stop' then
                    hash = 'setphoto:'..msg.to.id..':'..msg.from.id
                    redis:del(hash)
                    if msg.to.type == 'chat' then
                        reply_msg(msg.id, ' '..lang_text(msg.to.id, 'setPhotoAborted'), ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        reply_msg(msg.id, ' '..lang_text(msg.to.id, 'setPhotoAborted'), ok_cb, true)
                    end
                else
                    hash = 'setphoto:'..msg.to.id..':'..msg.from.id
                    redis:set(hash, true)
                    if msg.to.type == 'chat' then
                        reply_msg(msg.id, ' '..lang_text(msg.to.id, 'sendPhoto'), ok_cb, true)
                    elseif msg.to.type == 'channel' then
                        reply_msg(msg.id, ' '..lang_text(msg.to.id, 'sendPhoto'), ok_cb, true)
                    end
                end
            else
                 reply_msg(msg.id,' '..lang_text(msg.to.id, 'setPhotoError'), ok_cb, true)
            end
            return
        else
            return
        end
	end
    if matches[1]:lower() == 'upchat' then
        if msg.to.type == 'chat' then
            if permissions(msg.from.id, msg.to.id, "tosupergroup") then
                chat_upgrade('chat#id'..msg.to.id, ok_cb, false)
                 reply_msg(msg.id,' '..lang_text(msg.to.id, 'chatUpgrade'), ok_cb, true)
            else
                return
            end
        else
            reply_msg(msg.id,' '..lang_text(msg.to.id, 'notInChann'), ok_cb, true)
        end
	end
    if matches[1]:lower() == 'setabout' then
        if permissions(msg.from.id, msg.to.id, "description") then
            local text = matches[2]
            local chat = 'channel#id'..msg.to.id
            if msg.to.type == 'channel' then
                channel_set_about(chat, text, ok_cb, false)
                 reply_msg(msg.id,' '..lang_text(msg.to.id, 'desChanged'), ok_cb, true)
            else
                 reply_msg(msg.id,' '..lang_text(msg.to.id, 'desOnlyChannels'), ok_cb, true)
            end
        else
            return
        end
	end
    if matches[1]:lower() == 'mute' and matches[2] == 'all' and matches[3] and not matches[4] then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		print(1)
    		local hash = 'muteall:'..msg.to.id
    		redis:setex(hash, tonumber(matches[3]), true)
    		print(2)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:2'), ok_cb, true)
        else
            return
        end
	end
    if matches[1]:lower() == 'stats mute all' then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
		    local t = redis:ttl('muteall:'..msg.to.id)
			local m = 60
			local h = 3600
			local d = 86400
			local hash_s = math.floor(t + 1 )
			local hash_m = math.floor(t / m ) + 1
			local hash_h = math.floor(t / h ) + 1
			local hash_d = math.floor(t / d ) + 1
             return reply_msg(msg.id, lang_text(msg.to.id, 'mttxt')..'\n\n'..hash_s..' ' ..lang_text(msg.to.id, 'mts')..'\n'..hash_m..' '..lang_text(msg.to.id, 'mtm')..'\n'..hash_h..' '..lang_text(msg.to.id, 'mth')..'\n'..hash_d..' '..lang_text(msg.to.id, 'mtd'),ok_cb,false)
        else
            return
        end
	end
    if matches[1]:lower() == 'mute' and matches[2]:lower() == 'all' and matches[3] and matches[4] == 'h' then
	    local hash = 'muteall:'..msg.to.id
        if permissions(msg.from.id, msg.to.id, "muteall") then
	        if tonumber(matches[3]) > 24 then
			reply_msg(msg.id,lang_text(msg.to.id, 'up24'),ok_cb,false)
			elseif tonumber(matches[3]) < 1 then
			reply_msg(msg.id,lang_text(msg.to.id, 'down1'),ok_cb,false)
		    end
		 if matches[3] == '1' then
    		redis:setex(hash, tonumber(3600), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '2' then
    		redis:setex(hash, tonumber(7200), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '3' then
    		redis:setex(hash, tonumber(10800), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '4' then
    		redis:setex(hash, tonumber(14400), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '5' then
    		redis:setex(hash, tonumber(18000), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '6' then
    		redis:setex(hash, tonumber(21600), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '7' then
    		redis:setex(hash, tonumber(25200), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '8' then
    		redis:setex(hash, tonumber(28800), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '9' then
    		redis:setex(hash, tonumber(32400), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '10' then
    		redis:setex(hash, tonumber(36000), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '11' then
    		redis:setex(hash, tonumber(39600), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '12' then
    		redis:setex(hash, tonumber(43200), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '13' then
    		redis:setex(hash, tonumber(16800), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '14' then
    		redis:setex(hash, tonumber(50400), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '15' then
    		redis:setex(hash, tonumber(54000), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '16' then
    		redis:setex(hash, tonumber(57600), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '17' then
    		redis:setex(hash, tonumber(61200), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '18' then
    		redis:setex(hash, tonumber(64800), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '19' then
    		redis:setex(hash, tonumber(68400), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '20' then
    		redis:setex(hash, tonumber(72000), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '21' then
    		redis:setex(hash, tonumber(75600), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '22' then
    		redis:setex(hash, tonumber(79200), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '23' then
    		redis:setex(hash, tonumber(82800), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
         end
		 if matches[3] == '24' then
    		redis:setex(hash, tonumber(86400), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:3'), ok_cb, true)
	  end
   end
end
    if matches[1]:lower() == 'mute' and matches[2]:lower() == 'all' and matches[3] and matches[4] == 'd' then
	    local hash = 'muteall:'..msg.to.id
        if permissions(msg.from.id, msg.to.id, "muteall") then
	        if tonumber(matches[3]) > 7 then
			reply_msg(msg.id,lang_text(msg.to.id, 'up24'),ok_cb,false)
			elseif tonumber(matches[3]) < 1 then
			reply_msg(msg.id,lang_text(msg.to.id, 'down1'),ok_cb,false)
		    end
		 if matches[3] == '1' then
    		redis:setex(hash, tonumber(86400), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:4'), ok_cb, true)
         end
		 if matches[3] == '2' then
    		redis:setex(hash, tonumber(172800), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:4'), ok_cb, true)
         end
		 if matches[3] == '3' then
    		redis:setex(hash, tonumber(259200), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:4'), ok_cb, true)
         end
		 if matches[3] == '4' then
    		redis:setex(hash, tonumber(345600), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:4'), ok_cb, true)
         end
		 if matches[3] == '5' then
    		redis:setex(hash, tonumber(432000), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:4'), ok_cb, true)
         end
		 if matches[3] == '6' then
    		redis:setex(hash, tonumber(518400), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:4'), ok_cb, true)
         end
		 if matches[3] == '7' then
    		redis:setex(hash, tonumber(604800), true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAllX:1')..' '..matches[3]..' '..lang_text(msg.to.id, 'muteAllX:4'), ok_cb, true)
       end
   end
end
    if matches[1]:lower() == 'mute' and matches[2] == 'all' and not matches[3] then
    	if permissions(msg.from.id, msg.to.id, "muteall") then
    		local hash = 'muteall:'..msg.to.id
    		redis:set(hash, true)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'muteAll'),ok_cb,false)
        else
            return
        end
	end
    if matches[1]:lower() == 'unmute' and matches[2] == 'all' then
    	if permissions(msg.from.id, msg.to.id, "unmuteall") then
    		local hash = 'muteall:'..msg.to.id
    		redis:del(hash)
             reply_msg(msg.id,' '..lang_text(msg.to.id, 'unmuteAll'), ok_cb, true)
        else
            return
        end
	end
    if matches[1]:lower() == 'cgp' and matches[2] then
		if permissions(msg.from.id, msg.to.id, "creategroup") then
	            group_name = matches[2]
		     reply_msg(msg.id,create_group(msg, group_name), ok_cb, true)
		end
    elseif matches[1] == 'chat_created' and msg.from.id == 0 then
        return lang_text(msg.to.id, 'newGroupWelcome')
    end
    if matches[1]:lower() == 'plist' or matches[1] == 'nerkh' then
             reply_msg(msg.id,'<b>لیست قیمت های خرید گروه با</b> <a href="https://telegram.me/bIackplus">BlackPlus</a>\n\n<i> - 1 ماهه > 5000 تومان</i>\n<i> - 3 ماهه > 10000 تومان</i>\n<i> - نامحدود > 20000 تومان</i>',ok_cb,false)
    end
    if matches[1]:lower() == 'help' and permissions(msg.from.id, msg.to.id, "help") then
    local uhelp = "راهنمای بات ضد اسپم BlackPlus ( برای کاربران عادی )\nدرصورت ابهام میتونید با دستور linksp/ لینک گروه پشتیبانی را دریافت کنید و  مشکلتون رو مطرح کنید! \n〰〰〰〰〰〰〰〰〰\n#set number\nثبت کردن شماره شما در ربات\n\n#del number\nپاک کردن شمازه تنظیم شده در ربات\n\n#id\nنمایش اطلاعاتی درباره شما\n\n#id [username | reply ]\nنمایش اطلاعات یک فرد\n\nنمایش اطلاعاتی درباره شما\n\n#myinfo\nنمایش اطلاعات کاملی از شما\n\n#my number\nنشان دادن شماره شما\n\n#me\nنمایش تعداد پیام های ارسال شده توسط شما و تعداد پیام های ارسالی در گروه!\n➖➖➖➖➖➖\n#sticker [reply]\nبا ریپلای کردن عکس میتوانید آن را به استیکر تبدیل کنید!\n\n#photo [reply]\nبا ریپلای کردن استیکر میتوانید آن را به عکس تبدیل کنید!\n\n#file [reply]\nبا ریپلای کردن عکس یا استیکر میتوانید آن را به فایل png تبدیل کنید و با ارسال اون به @Sticker پک استیکر بسازید!\n\n#sticker [text]\nتبدیل متن شما به استیکر ...\n\n#sticker [text] [color]\nتبدیل متن شما به استیکر با تنظیم رنگ ...\n\n#sticker [text] [color] [font]\nتبدیل متن شما به استیکر با تنظیم رنگ و فونت...\n\n\n( Supported fonts : [fun|italic|bold|arial] )\n( Supported colors : [black|red|blue|yellow|pink|orange|brown] )\n➖➖➖➖➖➖\n#version\nنمایش ورژن و ادمین های ربات!\n\n#plist\nدریافت لیست قیمت برای خرید گروه...\n\n#time\nنمایش زمان و تاریخ\n\n#ping\nتست آنلاین یا آفلاین بودن ربات...\n\n#stats\nنمایش اطلاعاتی درباره ربات\n\n| Channel : @Black_CH |\n"
    local ohelp = "راهنمای بات ضد اسپم BlackPlus ( برای مدیر های گروه )\nدرصورت ابهام میتونید با دستور linksp/ لینک گروه پشتیبانی را دریافت کنید و  مشکلتون رو مطرح کنید! \n〰〰〰〰〰〰〰〰〰\n\n#ban [username|id| Reply]\nاخراج کردن یک فرد از گروه به صورت دائمی\n\n#unban [username|id| Reply]\nخارج کردن یک فرد از حالت اخراج دائمی!\n\n#kick [username|id| Reply]\nکیک کردن یک فرد از گروه\n\n#muteuser [Username|id|Reply]\nسایلنت کردن یک کاربر خاص در گروه\n\n#unmuteuser [Username|id|Reply]\nآنسایلنت کردن یک کاربر خاص در گروه\n\n#mutelist\nنمایش لیست افراد میوت شده.\n\n#banlist\nنمایش لیست افراد بن شده از گروه.\n\n#del [Reply|Number]\nپاک کردن تعداد پیام های مورد نظر با ریپلی و تعداد!\n\n#clean [rules|cmds|link|banlist|mutelist|filterlist|modlist|welcome]\n\nپاک کردن [قوانین گروه|دستور های تنظیم شده برای گروه|لینک گروه|لیست افراد بن شده|لیست افراد میوت شده|لیست کلمات فیلتر شده|مدیر های گروه|پیام خوشامد گویی]\n➖➖➖➖➖➖\n#c command\nساختن یک دستور با پسخ برای گروه شما\n\n#cmds\nلیست دستور های ساخته شده برای گروه\n\n#del command \nحذف یکی از دستور های تنظیم شده\n➖➖➖➖➖➖\n#admins\nنمایش لیست ادمین های گروه\n\n#gadmins\nنمایش لیست ادمین های بلک پلاس\n\n#info\nنشان دادن اطلاعاتی درباره گروه\n\n#gid\nدریافت کد 40 رقمی مخصوص گروه برای ارسال کردن به تیم پشتیبانی.\n➖➖➖➖➖➖\n#filter [word]\nفیلتر کردن یک کلمه\n\n#rw [word]\nحذف کردن کلمه از لیست فیلتر کلمات\n\n#filterlist\nنشان دادن کلمه های فیلتر شده\n➖➖➖➖➖➖\n#set welcome [welcome msg]\nتنظیم کردن یک متن به عنوان متن خوشامد گویی.\nبرای نشان دادن ایدی و اسم از مثال زیر استفاده کنید.\n\n#set welcome Salam @{username} \nbe gorooh e {gpname} khosh oomadi\nesmet {firstname}\nfamilit {lastname}\n\n\n#get welcome\nمشاهده متن خوشامد گویی.\n\n#welcome on\nفعال کردن پیام خوشامد گویی.\n\n#welcome off\nغیر فعال کردن پیام خوشامد گویی.\n➖➖➖➖➖➖\n#ownerlist\nنمایش ادمین های اصلی ربات در گروه.\n\n#modlist\nنمایش مدیران ربات در گروه( افرادی که توسط Owmer ادمین شدند.\n\n#promote [username|id|Reply]\nارتقاء مقام کاربر به ناظم گروه (فقط  اونر های گروه میتوانند پروموت کنند!!)\n\n#demote [username|id|Reply]\nخلع مقام کردن کاربر از سمت ناظم ها (فقط  اونر های گروه میتوانند دیموت کنند!!)\n➖➖➖➖➖➖\n#setname [text]\nتغییر اسم گروه\n\n#setphoto\nجایگزین کردن عکس گروه\n\n#setphoto stop\n\nدر صورتی که دستور #setphoto رو فرستاده باشید با این دستور میتوانید دستور رو لغو کنید.\n➖➖➖➖➖➖\n#newlink\nساختن لینک جدید\n\n#newlink pv\nساختن لینک جدید و ارسال آن در پیوی شما.\n\n#link\nگرفتن لینک گروه.\n\n#link pv\nارسال لینک گروه در پیوی شما.\n\n#linksp \nدریافت لینک گروه پشتیبانی.\n\n#setlink\nتنظیم کردن لینک جدید برای گروه.\n➖➖➖➖➖➖\n#setabout [text]\nگذاشتن متن توضیحات برای سوپر گروه (این متن در بخش توضیحات گروه نمایش داده میشه)\n\n#setrules [text]\nگذاشتن قوانین برای گروه\n\n#rules\nنمایش قوانین\n➖➖➖➖➖➖\n#lock [links|flood|spam|arabic|member|rtl|sticker|reply|kickme|TgService|contacts|forward|badword|emoji|english|tag|webpage]\nقفل کردن لینک گروها-اسپم-متن و اسم های بزرگ -زبان فارسی-تعداد اعضا-کاراکتر های غیر عادی-استیکر-مخاطبین-فروارد-فوش-اموجی-انگلیسی-تگ-لینک سایت\n\n#unlock [موارد لاک شده]\nباز کردن قفل امکانات بالا\n\n#mute [all|audio|gifs|photo|video|text]\nپاک کردن سریع همه پیغام ها-عکس ها-گیف ها-صدا های ضبط شده-فیلم-متن\n\n#unmute [all|audio|gifs|photo|video|text]\nباز کردن قفل امکانات بالا\n\n#mute all [time]\nمیوت کردن تمامی پیام های سوپرگروه با زمان \n(نکته : برای میوت کردن با زمان زیاد از روش زیر استفاده کنید.)\n\n/mute all 1\nبرای میوت کردن 1 ثانیه\n\n/mute all 1h\nبرای میوت کردن 1 ساعته\n\n/mute all 1d\nبرای میوت کردن 1 روزه\n\n/stats mute all\nنمایش زمان دقیق آنمیوت شدن گروه به روز/ساعت/ثانیه\n\n#setflood [value]\nگذاشتن value به عنوان حساسیت اسپم\n\n#setfloodtime [value]\nتنظیم زمان بررسی اسپم ها در گروه\n\n#setchar [value]\nتنظیم بیشترین حروف مجاز در پیام ها\n( در صورتی که کاربر پبامش بیشتر از عدد تنظیم شده باشد, پیامش پاک میشود... )\n( برای قعال شدن این دستور از دستور /lock spam استفاده کنید )\n➖➖➖➖➖➖\n#settings\nنمایش تنظیمات گروه.\n\n#muteslist\nنمایش لیست میوت ها.\n\n#reset group\nبرای بازگزداندن همه ی تنظیمات ربات در گروه به حالت اول.\n(لیست مدیران/لینک گروه/قوانین گروه/افراد بن شده/افراد میوت شده/تنظیمات و ... پاک میشود)\n➖➖➖➖➖➖\n#setlang [en|fa]\n\nتغییر زبان ربات در گروه.( en = english | fa = persian)\n\n| Channel : @Black_CH |\n"
	   reply_msg(msg.id,uhelp,ok_cb,false)
	   reply_msg(msg.id,ohelp,ok_cb,false)
	elseif matches[1]:lower() == 'help' and not permissions(msg.from.id, msg.to.id, "help") then
	    local uhelp = "راهنمای بات ضد اسپم BlackPlus ( برای کاربران عادی )\nدرصورت ابهام میتونید با دستور linksp/ لینک گروه پشتیبانی را دریافت کنید و  مشکلتون رو مطرح کنید! \n〰〰〰〰〰〰〰〰〰\n#set number\nثبت کردن شماره شما در ربات\n\n#del number\nپاک کردن شمازه تنظیم شده در ربات\n\n#id\nنمایش اطلاعاتی درباره شما\n\n#id [username | reply ]\nنمایش اطلاعات یک فرد\n\nنمایش اطلاعاتی درباره شما\n\n#myinfo\nنمایش اطلاعات کاملی از شما\n\n#my number\nنشان دادن شماره شما\n\n#me\nنمایش تعداد پیام های ارسال شده توسط شما و تعداد پیام های ارسالی در گروه!\n➖➖➖➖➖➖\n#sticker [reply]\nبا ریپلای کردن عکس میتوانید آن را به استیکر تبدیل کنید!\n\n#photo [reply]\nبا ریپلای کردن استیکر میتوانید آن را به عکس تبدیل کنید!\n\n#file [reply]\nبا ریپلای کردن عکس یا استیکر میتوانید آن را به فایل png تبدیل کنید و با ارسال اون به @Sticker پک استیکر بسازید!\n\n#sticker [text]\nتبدیل متن شما به استیکر ...\n\n#sticker [text] [color]\nتبدیل متن شما به استیکر با تنظیم رنگ ...\n\n#sticker [text] [color] [font]\nتبدیل متن شما به استیکر با تنظیم رنگ و فونت...\n\n\n( Supported fonts : [fun|italic|bold|arial] )\n( Supported colors : [black|red|blue|yellow|pink|orange|brown] )\n➖➖➖➖➖➖\n#version\nنمایش ورژن و ادمین های ربات!\n\n#plist\nدریافت لیست قیمت برای خرید گروه...\n\n#time\nنمایش زمان و تاریخ\n\n#ping\nتست آنلاین یا آفلاین بودن ربات...\n\n#stats\nنمایش اطلاعاتی درباره ربات\n\n| Channel : @Black_CH |\n"
         reply_msg(msg.id,uhelp,ok_cb,false)
	end
  if matches[1]:lower() == 'banlist' and permissions(msg.from.id, msg.to.id, "settings") then
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local user_msg = msg.id
         return ban_list(chat_id, user_msg)
  end
  if matches[1]:lower() == 'modlist' then
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local user_msg = msg.id
         return modlist(chat_id, user_msg)
  end
  if matches[1]:lower() == 'ownerlist' or matches[1]:lower() == 'owner' then
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local user_msg = msg.id
         return ownerlist(chat_id, user_msg)
  end
    if matches[1]:lower() == 'mutelist' and permissions(msg.from.id, msg.to.id, "settings") then
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local user_msg = msg.id
         return mute_list(chat_id, user_msg)
  end
  if matches[1]:lower() == 'gmutelist' and is_sudo(msg) then
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local user_msg = msg.id
         return gmute_list(user_msg)
  end
  if matches[1]:lower() == 'blocklist' and is_sudo(msg) then
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local user_msg = msg.id
         return block_list(user_msg)
  end
    if matches[1]:lower() == 'gbanlist' and is_sudo(msg) then
  local chat_id = msg.to.id
  local user_id = msg.from.id
  local user_msg = msg.id
         return banall_list(user_msg)
  end
  if matches[1]:lower() == 'leave' and is_sudo(msg) then
	   leave_channel(get_receiver(msg), ok_cb, false)
  end
	if matches[1]:lower() == 'reload' and is_sudo(msg) then
		reload_plugins(true)
		return reply_msg(msg.id, "#BOT Reloaded By <b>|"..msg.from.id.."|</b> \n#All Plugins Reloaded! \n#All Changes <b>Succesfully Installed.</b>", ok_cb, false)
	end
    if matches[1]:lower() == 'me' then
        function round2(num, idp)
          return tonumber(string.format("%." .. (idp or 0) .. "f", num))
        end
        local hashs = 'mymsgs:'..msg.from.id..':'..msg.to.id
        local msgs = redis:get(hashs)
    	local gp = 'gpmsgs:'..msg.to.id
        local gpmsg = redis:get(gp) --You've sent 5(0%) and this group has 1260 messages
	    local darsad = msgs / gpmsg * 100
    	return reply_msg(msg.id,lang_text(msg.to.id, 'yousend')..' <code>'..msgs..' ('..round2(darsad)..'%)</code> '..lang_text(msg.to.id, 'gpmsgs')..' <code>'..gpmsg..'</code> '..lang_text(msg.to.id, 'msgsss')..'.',ok_cb,false)
    end
  if matches[1]:lower() == "spam" and is_sudo(msg) then
    local num = matches[2]
     local text = matches[3]
        for i=1,num do
            send_large_msg(receiver, text)
        end
  end
    if matches[1]:lower() == 'pvbanlist' then
	    local chat_id = msg.to.id
        local user_id = msg.from.id
        local user_msg = msg.id
              return pv(user_msg)
    end
    if matches[1]:lower() == 'unpvban' then
        if permissions(msg.from.id, msg.to.id, "ungban") then
        	chat_id = msg.to.id
        	chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, unpvban_by_reply, false)
                return
            end
            if not is_id(matches[2]) then
                local chat_type = msg.to.type
				chat_id = msg.to.id
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, unpvban_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user_id = matches[2]
                local hash =  'pvban:'
                redis:srem(hash, user_id)
				local blocklist =  'blocklist:'
                redis:srem(blocklist, user_id)
				unblock_user('user#id'..user_id, callback, false)
				        reply_msg(msg.id, 'کاربر با موفقیت از لیست خارج شد.', ok_cb,  true)
                return
            end
        else
            return
        end
	end
    if matches[1]:lower() == 'block' then
        if is_sudo(msg) then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, block_by_reply, false)
                return
            end
            if not dgt_id(matches[2]) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, block_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user = 'user#id'..matches[2]
		        block_user(user, callback, false)
			    local blocklist =  'blocklist:'
                redis:sadd(blocklist, matches[2])
                return reply_msg(msg.id,'#Done\nUser <b>'..matches[2]..'</b> #Blocked From Bot.',ok_cb,false)
            end
        else
            return
        end
	end
	if matches[1]:lower() == 'aass' and is_sudo(msg) then
         reply_msg(msg.id,msg.data,ok_cb,false)
	end
    if matches[1]:lower() == 'unblock' then
        if is_sudo(msg) then
            local chat_id = msg.to.id
            local chat_type = msg.to.type
            if msg.reply_id then
                get_message(msg.reply_id, unblock_by_reply, false)
                return
            end
            if not dgt_id(matches[2]) then
                local member = string.gsub(matches[2], '@', '')
                resolve_username(member, unblock_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
                return
            else
                local user = 'user#id'..matches[2]
		        unblock_user(user, callback, false)
				local blocklist =  'blocklist:'
                redis:srem(blocklist, matches[2])
                return reply_msg(msg.id,'#Done\nUser <b>'..matches[2]..'</b> #Unblocked From Bot.',ok_cb,false)
            end
        else
            return
        end
	  end
    end
  end
end
return {
    patterns = {
        '^[!/#]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss])$',
		'^[!/#]([Ss][Ee][Tt][Tt][Ii][Nn][Gg][Ss]) (.*)$',
		'^[!/#]([Mm][Uu][Tt][Ee][Ss][Ll][Ii][Ss][Tt])$',
		'^[!/#]([Gg][Mm][Uu][Tt][Ee][Ll][Ii][Ss][Tt])$',
		"^[#!/]([Uu][Nn][Pp][Vv][Bb][Aa][Nn]) (.*)$",
  	    "^[#!/]([Uu][Nn][Pp][Vv][Bb][Aa][Nn])$",
	    "^[#!/]([Pp][Vv][Bb][Aa][Nn][Ll][Ii][Ss][Tt])$",
		"^[#!/]([Ss][Pp][Aa][Mm]) (%d+) (.*)$",
		'^[!/#]([Ii][Dd])$',
		'^[!/#](aass)$',
        '^[!/#]([Ii][Dd]) (.*)$',
        '^[!/#]([Gg][Ii][Dd])$',
		'^(9678155681) (6324781252) (4364915821) (%d+)$',
        '^[!/#]([Ll][Oo][Cc][Kk]) (.*)$',   	
        '^[!/#]([Uu][Nn][Ll][Oo][Cc][Kk]) (.*)$',
	    '^[!/#]([Ss][Ee][Tt] [Ww][Ee][Ll][Cc][Oo][Mm][Ee]) (.*)',
	    '^[!/#]([Gg][Ee][Tt] [Ww][Ee][Ll][Cc][Oo][Mm][Ee])',
	    '^[!/#]([Ww][Ee][Ll][Cc][Oo][Mm][Ee] [Oo][Nn])',
	    '^[!/#]([Ww][Ee][Ll][Cc][Oo][Mm][Ee] [Oo][Ff][Ff])',
        '^[!/#]([Dd][Ee][Ll])$',
		'^[!/#](del) (%d+)$',
        '^[!/#]([Ss][Ee][Tt][Nn][Aa][Mm][Ee]) (.*)$',
	    '^[!/#]([Rr][Uu][Ll][Ee][Ss])$',
        '^[!/#]([Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss]) (.+)$',
        '^[!/#]([Cc][Ll][Ee][Aa][Nn]) (.*)$',
		'^[!/#]([Rr][Ee][Ss][Ee][Tt]) ([Gg][Rr][Oo][Uu][Pp])$',
        '^[!/#]([Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo])$',
        '^[!/#]([Ss][Ee][Tt][Pp][Hh][Oo][Tt][Oo]) (.*)$',
		"^[!/#]([Ii][Nn][Vv]) (.*)$",
		"^[!/#]([Ii][Nn][Vv])$",
		"^[!/#]([[Ii][Nn][Vv][Ii][Tt][Ee]) (.*)$",
		"^[!/#]([[Ii][Nn][Vv][Ii][Tt][Ee])$",
        '^[!/#]([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd][Tt][Ii][Mm][Ee]) (%d+)$',
		'^[!/#]([Ss][Ee][Tt][Cc][Hh][Aa][Rr]) (%d+)$',
        '^[!/#]([Ss][Ee][Tt][Ff][Ll][Oo][Oo][Dd]) (%d+)$',
        '^[!/#]([Mm][Uu][Tt][Ee]) (.*) (%d+)$',
		'^[!/#]([Mm][Uu][Tt][Ee]) (.*) (%d+)([hd])$',
        '^[!/#]([Mm][Uu][Tt][Ee]) (.*)$',
		'^[!/#]([Ss][Tt][Aa][Tt][Ss] [Mm][Uu][Tt][Ee] [Aa][Ll][Ll])$',
        '^[!/#]([Uu][Nn][Mm][Uu][Tt][Ee]) (.*)$',
        '^[!/#]([Nn][Ee][Ww][Ll][Ii][Nn][Kk])$',
        '^[!/#]([Ss][Ee][Tt][Ll][Ii][Nn][Kk])$',
        '([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)',
		'^[!/#]([Ss][Ee][Tt][Ll][Ii][Nn][Kk]) ([Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/%S+)$',
        '^[!/#]([Ll][Ii][Nn][Kk])$',
		'^[!/#]([Ll][Ii][Nn][Kk]) ([Pp][Vv])$',
	    '^[!/#]([Ss][Ee][Aa][Rr][Cc][Hh]) ([Gg][Rr][Oo][Uu][Pp][Ss]) (%d*)$',
		'^[!/#]([Ll][Ii][Nn][Kk][Ss][Pp])$',
        '^[!/#]([Ii][Nn][Ff][Oo])$',
		'^[!/#]([Aa][Dd][Mm][Ii][Nn][Ss])$',
		'^[!/#]([Hh][Ee][Ll][Pp])$',
		'^[!/#]([NnPp][EeLl][RrIi][KkSs][HhTt])$',
		'^[!/#]([Pp][Ii][Nn][Gg])$',
        '^[!/#]([Uu][Pp][Cc][Hh][Aa][Tt])$',
        '^[!/#]([Ss][Ee][Tt][Aa][Bb][Oo][Uu][Tt]) (.*)$',
        '^[!/#]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ee][Nn])$',
		'^[!/#]([Ss][Ee][Tt][Ll][Aa][Nn][Gg]) ([Ff][Aa])$',
        '^[!/#]([Ss][Ee][Tt][Cc][Mm][Dd]) ([Ee][Nn])$',
		'^[!/#]([Ss][Ee][Tt][Cc][Mm][Dd]) ([Ff][Aa])$',
        '^[!/#]([Cc][Gg][Pp]) (.*)$',
		'^[!/#]([Aa][Dd][Dd][Aa][Dd][Mm][Ii][Nn])$',
        '^[!/#]([Aa][Dd][Dd][Aa][Dd][Mm][Ii][Nn]) (.*)$',
		'^[!/#]([Rr][Ee][Mm][Aa][Dd][Mm][Ii][Nn])$',
        '^[!/#]([Rr][Ee][Mm][Aa][Dd][Mm][Ii][Nn]) (.*)$',
  	    '^[!/#]([Gg][Aa][Dd][Mm][Ii][Nn][Ss])$',
  	    '^[!/#]([Mm][Oo][Dd][Ll][Ii][Ss][Tt])$',
		'^[!/#]([Oo][Ww][Nn][Ee][Rr][Ll][Ii][Ss][Tt])$',
		'^[!/#]([Oo][Ww][Nn][Ee][Rr])$',
	    '^[!/#]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr])$',
	    '^[!/#]([Ss][Ee][Tt][Oo][Ww][Nn][Ee][Rr]) (.*)$',
		'^[!/#]([Dd][Ee][Mm][Oo][Ww][Nn][Ee][Rr])$',
	    '^[!/#]([Dd][Ee][Mm][Oo][Ww][Nn][Ee][Rr]) (.*)$',
	    '^[!/#]([Pp][Rr][Oo][Mm][Oo][Tt][Ee])$',
	    '^[!/#]([Pp][Rr][Oo][Mm][Oo][Tt][Ee]) (.*)$',
	    '^[!/#]([Dd][Ee][Mm][Oo][Tt][Ee])$',
	    '^[!/#]([Dd][Ee][Mm][Oo][Tt][Ee]) (.*)$',
		'^[!/#]([Bb][Ll][Aa][Cc][Kk])$', 
        '^[!/#]([Bb][Ll][Aa][Cc][Kk][Pp][Ll][Uu][Ss])$',
        '^[!/#]([Vv][Ee][Rr][Ss][Ii][Oo][Nn])$',
		'^[!/#]([Ee][Cc][Hh][Oo]) (.*)$', 
		'^[!/#]([Rr][Ee][Ll][Oo][Aa][Dd])$',
		'^[!/#]([Mm][Ee])$',
		'^[!/#]([Ll][Ee][Aa][Vv][Ee])$',
		'^[!/#]([Bb][Aa][Nn]) (.*)$',
        '^[!/#]([Bb][Aa][Nn])$',
		'^[!/#]([Bb][Aa][Nn][Ll][Ii][Ss][Tt])$',
		'^[!/#]([Gg][Bb][Aa][Nn][Ll][Ii][Ss][Tt])$',
		'^[!/#]([Mm][Uu][Tt][Ee][Ll][Ii][Ss][Tt])$',
		'^[!/#]([Bb][Ll][Oo][Cc][Kk][Ll][Ii][Ss][Tt])$',
        '^[!/#]([Uu][Nn][Bb][Aa][Nn]) (.*)$',
        '^[!/#]([Uu][Nn][Bb][Aa][Nn])$',
		'^[!/#]([Bb][Ll][Oo][Cc][Kk]) (.*)$',
		'^[!/#]([Uu][Nn][Bb][Ll][Oo][Cc][Kk]) (.*)$',
		'^[!/#]([Bb][Ll][Oo][Cc][Kk])$',
		'^[!/#]([Uu][Nn][Bb][Ll][Oo][Cc][Kk])$',
        '^[!/#]([Kk][Ii][Cc][Kk]) (.*)$',
        '^[!/#]([Kk][Ii][Cc][Kk])$',
        '^[!/#]([Kk][Ii][Cc][Kk][Mm][Ee])$',
        '^[!/#]([Bb][Aa][Nn][Aa][Ll][Ll]) (.*)$',
        '^[!/#]([Bb][Aa][Nn][Aa][Ll][Ll])$',
        '^[!/#]([Uu][Nn][Bb][Aa][Nn][Aa][Ll][Ll]) (.*)$',
        '^[!/#]([Uu][Nn][Bb][Aa][Nn][Aa][Ll][Ll])$',
        '^[!/#]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$',
        '^[!/#]([Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])$',
        '^[!/#]([Uu][Nn][Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$',
        '^[!/#]([Uu][Nn][Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])$',
        '^[!/#]([Gg][Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$',
        '^[!/#]([Gg][Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])$',
        '^[!/#]([Gg][Uu][Nn][Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr]) (.*)$',
        '^[!/#]([Gg][Uu][Nn][Mm][Uu][Tt][Ee][Uu][Ss][Ee][Rr])$',
		'^(لینک)$',
    },
    pre_process = pre_process,
    run = run
}
end
--[[



setlang

link





















]]
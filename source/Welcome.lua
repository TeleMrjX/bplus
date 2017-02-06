local function run(msg, matches, callback, extra)
local wlc = 'wlstat:'..msg.to.id
if redis:get(wlc) then
   local data = 'welcome:'..msg.to.id
   local group_welcome = redis:get(data)
   if msg.service and group_welcome then
       if matches[1] == 'chat_add_user' or 'chat_add_user_link' then
    if string.match(group_welcome, '{gpname}') then group_welcome = string.gsub(group_welcome, '{gpname}', ""..string.gsub(msg.to.print_name, "_", " ").."")
    end
      if string.match(group_welcome, '{firstname}') then group_welcome = string.gsub(group_welcome, '{firstname}', ""..(msg.action.user.first_name or '').."")
      end
        if string.match(group_welcome, '{lastname}') then group_welcome = string.gsub(group_welcome, '{lastname}', ""..(msg.action.user.last_name or '').."")
        end
          if string.match(group_welcome, '{username}') then group_welcome = string.gsub(group_welcome, '{username}', "@"..(msg.action.user.username or '').."")
           end
          return reply_msg(msg.id,group_welcome,ok_cb,false)
		end
      end
	 else
	return
   end
end

return {
  patterns = {
  "^!!tgservice (chat_add_user)$",
  "^!!tgservice (chat_add_user_link)$",
  },
  run = run,
}
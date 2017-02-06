function run(msg,matches)
     if is_sudo(msg) then
  local gps = redis:smembers("blackplus:groups")
  local users = redis:smembers("blackplus:users")
  local gps2 = redis:scard("blackplus:groups") + 48
  local m = 'cmdusers:'
  local msgs = redis:get(m)
  local users2 = redis:scard("blackplus:users") + 10
    if matches[1] == "bc/fwd groups" then
        redis:set("gps:waiting:"..msg.from.id,true)
        return reply_msg(msg.id,"<i>Please Send Your Msg Now!</i>\nI'll <b>Forward</b> Your Msg To <b>All Groups.</b>",ok_cb,false)
    elseif matches[1] == "bc/fwd users" then
        redis:set("users:waiting:"..msg.from.id,true)
        return reply_msg(msg.id,"<i>Please Send Your Msg Now!</i>\nI'll <b>Forward</b> Your Msg To <b>All Users.</b>",ok_cb,false)
    elseif matches[1] == "stats" then
        return reply_msg(msg.id,"<b>BlackPlus</b> Stats:\n\n<i>Users</i> : <code>"..users2.."</code>\n<i>Groups</i> : <code>"..gps2.."</code>\n<i>All Received Msgs</i> : <code>"..msgs.."</code>",ok_cb,false)
    elseif matches[1] == "bc groups" then
 for i=1, #gps do
           send_large_msg(gps[i],matches[2],ok_cb,false)
 end
    else
        if redis:get("gps:waiting:"..msg.from.id) then
  local id = msg.id
        if msg.text or msg.media then
 for i=1, #gps do
        fwd_msg(gps[i],id,ok_cb,false)
 end
    else
  for i=1, #gps do
        fwd_media(gps[i],id,ok_cb,false)
  end
end
        redis:del("gps:waiting:"..msg.from.id)
        return reply_msg(msg.id,"<b>Done</b>\nYour Msg Has Been <b>Forwarded</b> To <b>All Groups</b>",ok_cb,false)
    elseif redis:get("users:waiting:"..msg.from.id) then
  local id = msg.id
        if msg.text or msg.media then
  for i=1, #users do
           fwd_msg(users[i],id,ok_cb,false)
  end
     else
 for i=1, #users do
          fwd_media(users[i],id,ok_cb,false)
 end
        end
		redis:del("users:waiting:"..msg.from.id)
     return reply_msg(msg.id,"<b>Done</b>\nYour Msg Has Been <b>Forwarded</b> To <b>All Users</b>",ok_cb,false)
       end
    end
  end
end
local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
patterns = {
"^[!/#](bc/fwd groups)$",
"^[!/#](bc/fwd users)$",
"^[!/#](stats)$",
"^[!/#](bc groups) (.*)$",
"^(.*)$",
"%[(photo)%]",
"%[(document)%]",
"%[(video)%]",
"%[(audio)%]",
"%[(unsupported)%]",
"%[(contact)%]"
},
run = run,
pre_process = pre_process

}
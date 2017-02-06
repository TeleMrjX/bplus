local function get_variables_hash(msg)
  if msg.to.type == 'chat' or msg.to.type == 'channel' then
    return 'g:variables'
  end
end 

local function get_value(msg, var_name)
  local hash = get_variables_hash(msg)
  if hash then
    local value = redis:hget(hash, var_name)
    if not value then
      return
    else
      return value
    end
  end
end

local function get_variables_hash1(msg)
  if msg.to.type == 'chat' or msg.to.type == 'channel' then
    return 'chat:'..msg.to.id..':variables'
  end
end 

local function get_value1(msg, var_name)
  local hash = get_variables_hash1(msg)
  if hash then
    local value1 = redis:hget(hash, var_name)
    if not value1 then
      return
    else
      return value1
    end
  end
end

local function run(msg, matches)
  if matches[2] then
    local name = user_print_name(msg.from)
     reply_msg(msg.id,get_value(msg, matches[2]),ok_cb,false)
	 reply_msg(msg.id,get_value1(msg, matches[2]),ok_cb,false)
  else
    return
  end
end

return {
  patterns = {
    "^([/#!])(.+)$"
  },
  run = run
}
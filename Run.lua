package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("source/Management/configuration")
require("source/Management/limiter")

local f = assert(io.popen('/usr/bin/git describe --tags', 'r'))
VERSION = assert(f:read('*a'))
f:close()

function ok_cb(extra, success, result)
end
-- This function is called when tg receive a msg
function on_msg_receive (msg)
  if not started then
    return
  end

  msg = backward_msg_format(msg)

  local receiver = get_receiver(msg)
  --vardump(msg)
  --vardump(msg)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
      if redis:get("bot:markread") then
        if redis:get("bot:markread") == "on" then
          mark_read(receiver, ok_cb, false)
        end
      end
    end
  end
end
function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)
  -- See plugins/isup.lua as an example for cron

  _config = load_config()

  _gbans = load_gbans()

  -- load plugins
  plugins = {}
  load_plugins()

  -- load language
  lang = {}
  load_lang()
end

function msg_valid(msg)
  -- Don't process outgoing messages
  if msg.out then
    return false
  end
  -- Before bot was started
  if msg.date < now then
    return false
  end

  if msg.unread == 0 then
    return false
  end

  if not msg.to.id then
    return false
  end

  if not msg.from.id then
    return false
  end

  if msg.from.id == our_id then
    return false
  end

  if msg.to.type == 'encr_chat' then
    return false
  end

  if msg.from.id == 777000 then
    return false
  end
if msg.to.type == "user" then
  if not redis:sismember("blackplus:users",get_receiver(msg)) then
    redis:sadd("blackplus:users",get_receiver(msg))
  end
  else
  if not redis:sismember("blackplus:groups",get_receiver(msg)) then
    redis:sadd("blackplus:groups",get_receiver(msg))
    return true
  end
end
  return true
end

--
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('> Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end
  return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = ''
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)

  -- Go over patterns. If one matches it's enough.
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("Matches >>>  ", pattern)

      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
  send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, 'source/Management/db.lua')
  print ('saved config into source/Management/db.lua')
end

function save_gbans( )
  serialize_to_file(_gbans, 'source/Management/BlackPlus_GbanList.BlackPlus')
  print ('saved gban into source/Management/BlackPlus_GbanList.BlackPlus')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('source/Management/db.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("source/Management/db.lua")()
  for v,user in pairs(config.sudo_users) do
    print('\27[93m > Developer:\27[39m'..' '..'@MehdiHS')
  end
  return config
end

function load_gbans( )
  local f = io.open('source/Management/BlackPlus_GbanList.BlackPlus', "r")
  -- If gbans.lua doesn't exist
  if not f then
    print ("Created new gbans file: source/Management/BlackPlus_GbanList.BlackPlus")
    create_gbans()
  else
    f:close()
  end
  local gbans = loadfile ("source/Management/BlackPlus_GbanList.BlackPlus")()
  return gbans
end

-- Create a basic config.json file and saves it.
function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
  enabled_plugins = {
    "arabic",
    "bot",
    "commands",
    "export_gban",
    "giverank",
    "id",
    "links",
    "moderation",
    "plugins",
    "rules",
    "settings",
    "spam",
    "version",
    },
  enabled_lang = {
    "english_lang",
    "persian_lang",
  },
    sudo_users = {our_id},
    admin_users = {},
    disabled_channels = {}
  }
  serialize_to_file(config, 'source/Management/db.lua')
  print ('saved config into source/Management/db.lua')
end

function create_gbans( )
  -- A simple config with basic plugins and ourselves as privileged user
  gbans = {
    gbans_users = {}
  }
  serialize_to_file(gbans, 'source/Management/BlackPlus_GbanList.BlackPlus')
  print ('saved gbans into source/Management/BlackPlus_GbanList.BlackPlus')
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)
  --vardump (chat)
end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.lua
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do

    local ok, err =  pcall(function()
      local t = loadfile("source/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
      print(tostring(io.popen("lua source/"..v..".lua"):read('*all')))
      print('\27[31m'..err..'\27[39m')
    end
  end
end

-- Enable lang in config.lua
function load_lang()
  for k, v in pairs(_config.enabled_lang) do
    local ok, err =  pcall(function()
      local t = loadfile("source/BlackPlus_languages/"..v..'.lua')()
      plugins[v] = t
    end)
    if not ok then
    end
  end
end

-- Call and postpone execution for cron plugins
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end

  -- Called again in 5 mins
  postpone (cron_plugins, false, 5*60.0)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false
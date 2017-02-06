local sudos = {
    "plugins",
    "rank_admin",
    "lang_install",
    "tosupergroup",
 	"gban_installer"
  }
 local admins = {
 	"rank_mod",
	"rank_owner",
 	"gban",
 	"ungban",
 	"creategroup",
 	"addbots",
 	"rank_guest",
 	"export_gban"
}
local owners = {
    "bot",
	"rank_md",
	"lang",
}
local mods = {
	"whois",
	"kick",
	"add",
	"ban",
 	"description",
	"unban",
	"lockmember",
	"mute",
	"unmute",
 	"setname",
    "set_lang",
	"setlink",
	"link",
 	"setrules",
 	"setphoto",
 	"setlink",
	"admins",
	"help",
 	"members",
 	"welcome",
 	"mods",
	"flood",
	"commands",
	"settings",
	"mod_commands",
	"no_flood_ban",
	"muteall",
	"rules",
	"pre_process"
}

local function get_tag(plugin_tag)
	for v,tag in pairs(sudos) do
	    if tag == plugin_tag then
	       	return 4
	    end
  	end
  	for v,tag in pairs(admins) do
	    if tag == plugin_tag then
	       	return 3
	    end
  	end
	for v,tag in pairs(owners) do
	    if tag == plugin_tag then
	       	return 2
	    end
  	end
  	for v,tag in pairs(mods) do
	    if tag == plugin_tag then
	       	return 1
	    end
  	end
  	return 0
end

local function user_num(user_id, chat_id)
	if new_is_sudo(user_id) then
		return 4
	elseif is_admin(user_id) then
		return 3
	elseif is_owner(chat_id, user_id) then
		return 2
	elseif is_mod(chat_id, user_id) then
		return 1
	else
		return 0
	end
end

function permissions(user_id, chat_id, plugin_tag)
	local user_is = get_tag(plugin_tag)
	local user_n = user_num(user_id, chat_id)
	if user_n >= user_is then
		return true
	else
		return false
	end
end

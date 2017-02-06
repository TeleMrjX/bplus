
local LANG = 'en'

local function run(msg, matches)
	if permissions(msg.from.id, msg.to.id, "lang_install") then

		-------------------------
		-- Translation version --
		-------------------------
		set_text(LANG, 'version', '0.5')
		set_text(LANG, 'versionExtended', 'Translation version 0.5 By MehdiHS')

		-------------
		-- Plugins --
		-------------

		-- global plugins --
		set_text(LANG, 'cnotmod', 'You <b>Can,t</b> <i>[Kick/Ban]</i> Moderators!!')
		set_text(LANG, 'cnotadmin', 'You <b>Can,t</b> <i>[Kick/Ban/Banall]</i> Global Admins!!')
		set_text(LANG, 'cnotmmod', 'You <b>Can,t</b> <i>[Mute]</i> Moderators!!')
		set_text(LANG, 'caddmt', 'You <b>Can,t</b> <i>[Mute]</i> Global Admins!!')
		
		-- welcome.lua
		set_text(LANG, 'weloff', '#Done\nWelcome Disabled In This Supergroup.')
		set_text(LANG, 'welon', '#Done\nWelcome Enabled In This Supergroup.')
		set_text(LANG, 'welnew', 'Welcome Msg Has Been Saved!\nWlc Text:\n\n')
		set_text(LANG, 'gwlc', 'Welcome Text For This Group:\n\n')
		set_text(LANG, 'nogwlc', 'Welcome #Not Seted For This Group!')

		set_text(LANG, 'allowedSpamT', '> Group #spam has been #unlocked.')
		set_text(LANG, 'allowedSpamL', '> SuperGroup #spam has been #unlocked.')
		set_text(LANG, 'notAllowedSpamT', '> Group #spam is #already locked.')
		set_text(LANG, 'notAllowedSpamL', '> SuperGroup #spam is #already locked.')

		-- Time.lua --
		set_text(LANG, 'time1', 'Time : ')
		set_text(LANG, 'time2', 'Date (iran) : ')
		set_text(LANG, 'time3', 'Date (Global) : ')
		
		-- Me.lua --
		set_text(LANG, 'yousend', 'You,ve Sent')
		set_text(LANG, 'gpmsgs', 'Messages And This Group Has')
		set_text(LANG, 'msgsss', 'Messages')

		set_text(LANG, 'longmsg', 'Send a message with more than')
		set_text(LANG, 'longmsg2', 'characters are not allowed!!')
		set_text(LANG, 'longmsg3', 'Msg Sender Info')
		set_text(LANG, 'gchar', 'Max Char Sensitivity')
		set_text(LANG, 'charmax', '> #Max_Character Sensitivity has been set to : ')
		set_text(LANG, 'errchar', '*Wrong number,range is [1000-5000]')
		
		-- bot.lua --
		set_text(LANG, 'botOn', '#Bot Now #Work In This Supergroup')
		set_text(LANG, 'botOff', '#Bot Now #Not Work In This Supergroup')

		-- settings.lua --
		set_text(LANG, 'user', 'User')
		set_text(LANG, 'isFlooding', '\nSpamming #Not Allowed Here.\nSpammer Banned!!')

		set_text(LANG, 'resetgp', '#Done\nGroup was reseted!\n- Check Settings And more...')
		set_text(LANG, 'linkpvsend', '#Done\nGroup Link Was Sent On Your Pv.')
		set_text(LANG, 'gplinkonpv', 'Your Group Link > ') 
        set_text(LANG, 'notfwdfromblackplus', '#Error\n> Please Forward Msg From BIackPlus Only')
		set_text(LANG, 'owneronlygid', '#Error\n> For #Moderators Only!')
		set_text(LANG, 'notwkinchat', '#Error\n> This Plugin Was #Not work in normal groups!')
		set_text(LANG, 'gpdetected', 'Search #Success\nResults:\n\n ')
		
		set_text(LANG, 'noStickersT', '> #Sticker posting has been #locked')
		set_text(LANG, 'noStickersL', '> #Sticker posting has been #locked')
		set_text(LANG, 'stickersT', '> #Sticker posting has been #unlocked')
		set_text(LANG, 'stickersL', '> #Sticker posting has been #unlocked')
		
		set_text(LANG, 'noTgservicesT', '> #TGservice has been #unlocked')
		set_text(LANG, 'noTgservicesL', '> #TGservice has been #unlocked')
		set_text(LANG, 'tgservicesT', '> #TGservice has been #locked')
		set_text(LANG, 'tgservicesL', '> #TGservice has been #locked')
		
		set_text(LANG, 'LinksT', '> #Link posting has been #unlocked')
		set_text(LANG, 'LinksL', '> #Link posting has been #unlocked')
		set_text(LANG, 'noLinksT', '> #Link posting has been #locked')
		set_text(LANG, 'noLinksL', '> #Link posting has been #locked')

		set_text(LANG, 'TagT', '> #Tag posting has been #unlocked')
		set_text(LANG, 'TagL', '> #Tag posting has been #unlocked')
		set_text(LANG, 'noTagT', '> #Tag posting has been #locked')
		set_text(LANG, 'noTagL', '> #Tag posting has been #locked')
		
		set_text(LANG, 'CmdsT', '> #Bot Commands Has Been #unlocked\n[Now All Members Can Use Normal Commands.)')
		set_text(LANG, 'CmdsL', '> #Bot Commands Has Been #unlocked\n[Now All Members Can Use Normal Commands.)')
		set_text(LANG, 'noCmds', '> #Bot Commands Has Been #locked\n[Now All Members Can Use Normal Commands.)')
		set_text(LANG, 'noCmdsL', '> #Bot Commands Has Been #locked\n[Now All Members Can`t Use Normal Commands.)')
		
		set_text(LANG, 'webpageT', '> #WebLink posting has been #unlocked')
		set_text(LANG, 'webpageL', '> #WebLink posting has been #unlocked')
		set_text(LANG, 'nowebpageT', '> #WebLink posting has been #locked')
		set_text(LANG, 'nowebpageL', '> #WebLink posting has been #locked')
		
		set_text(LANG, 'emojiT', '> #Emoji Has been #unlocked!')
		set_text(LANG, 'emojiL', '> #Emoji Has been #unlocked!')
		set_text(LANG, 'noemojiT', '> #Emoji Has been #locked!')
		set_text(LANG, 'noemojiL', '> #Emoji Has been #locked!')
		
		set_text(LANG, 'badwordT', '> #Badwords Has been #unlocked!')
		set_text(LANG, 'badwordL', '> #Badwords Has been #unlocked!')
		set_text(LANG, 'nobadwordT', '> #Badwords Has been #locked!')
		set_text(LANG, 'nobadwordL', '> #Badwords Has been #locked!')
		
		set_text(LANG, 'gifsT', '> #Gifs Has been #unmuted')
		set_text(LANG, 'gifsL', '> #Gifs Has been #unmuted')
		set_text(LANG, 'noGifsT', '> #Gifs Has been #muted')
		set_text(LANG, 'noGifsL', '> #Gifs Has been #muted')
		
		set_text(LANG, 'hashtagT', '> #HashTag posting has been #unlocked')
		set_text(LANG, 'hashtagL', '> #HashTag posting has been #unlocked')
		set_text(LANG, 'nohashtagT', '> #HashTag posting has been #locked')
		set_text(LANG, 'nohashtagL', '> #HashTag posting has been #locked')
		
		set_text(LANG, 'forwardT', '> #Forward Msg has been #unlocked')
		set_text(LANG, 'forwardL', '> #Forward Msg has been #unlocked')
		set_text(LANG, 'noforwardT', '> #Forward Msg has been #locked')
		set_text(LANG, 'noforwardL', '> #Forward Msg has been #locked')

		set_text(LANG, 'replyT', '> #Reply has been #unlocked')
		set_text(LANG, 'replyL', '> #Reply has been #unlocked')
		set_text(LANG, 'noreplyT', '> #Reply has been #locked')
		set_text(LANG, 'noreplyL', '> #Reply has been #locked')
		
		set_text(LANG, 'contactT', '> #Contact Posting Has Been #unlocked')
		set_text(LANG, 'contactL', '> #Contact Posting Has Been #unlocked')
		set_text(LANG, 'nocontactT', '> #Contact Posting Has Been #locked')
		set_text(LANG, 'nocontactL', '> #Contact Posting Has Been #locked')
		
		set_text(LANG, 'textsT', '> #Text has been #muted')
		set_text(LANG, 'textsL', '> #Text has been #muted')
		set_text(LANG, 'notextsT', '> #Text has been #unmuted')
		set_text(LANG, 'notextsL', '> #Text has been #unmuted')
		
		set_text(LANG, 'photosT', '> #Photo Has been #unmuted')
		set_text(LANG, 'photosL', '> #Photo Has been #unmuted')
		set_text(LANG, 'noPhotosT', '> #Photo Has been #muted')
		set_text(LANG, 'noPhotosL', '> #Photo Has been #muted')

		set_text(LANG, 'videoT', '> #Video Has been #unmuted')
		set_text(LANG, 'videoL', '> #Video Has been #unmuted')
		set_text(LANG, 'novideoT', '> #Video Has been #muted')
		set_text(LANG, 'novideoL', '> #Video Has been #muted')
		
		set_text(LANG, 'botsT', '> #Bots protection has been #disabled')
		set_text(LANG, 'botsL', '> #Bots protection has been #disabled')
		set_text(LANG, 'noBotsT', '> #Bots protection has been #enabled')
		set_text(LANG, 'noBotsL', '> #Bots protection has been #enabled')

		set_text(LANG, 'arabicT', '> #Arabic/Persian has been #unlocked')
		set_text(LANG, 'arabicL', '> #Arabic/Persian has been #unlocked')
		set_text(LANG, 'noArabicT', '> #Arabic/Persian has been #locked')
		set_text(LANG, 'noArabicL', '> #Arabic/Persian has been #locked')

		set_text(LANG, 'englishT', '> #English has been #unlocked')
		set_text(LANG, 'englishL', '> #English has been #unlocked')
		set_text(LANG, 'noenglishT', '> #English has been #locked')
		set_text(LANG, 'noenglishL', '> #English has been #locked')
		
		set_text(LANG, 'audiosT', '> #Audio has been #unmuted')
		set_text(LANG, 'audiosL', '> #Audio has been #unmuted')
		set_text(LANG, 'noAudiosT', '> #Audio has been #muted')
		set_text(LANG, 'noAudiosL', '> #Audio has been #muted')
		
		set_text(LANG, 'gpwlcT', '> Welcome Msg Has Been #Enabled.')
		set_text(LANG, 'gpwlcL', '> Welcome Msg Has Been #Enabled.')
		set_text(LANG, 'nogpwlcT', '> Welcome Msg Has Been #Disabled.')
		set_text(LANG, 'nogpwlcL', '> Welcome Msg Has Been #Disabled.')

		set_text(LANG, 'kickmeT', '> #kickme has been #unlocked')
		set_text(LANG, 'kickmeL', '> #kickme has been #unlocked')
		set_text(LANG, 'noKickmeT', '> #kickme has been #locked')
		set_text(LANG, 'noKickmeL', '> #kickme has been #locked')

		set_text(LANG, 'floodT', '> #Flood has been #unlocked')
		set_text(LANG, 'floodL', '> #Flood has been #unlocked')
		set_text(LANG, 'noFloodT', '> #Flood has been #locked')
		set_text(LANG, 'noFloodL', '> #Flood has been #locked')

		set_text(LANG, 'floodTime', '> #Flood_time Check has been set to ')
		set_text(LANG, 'floodMax', '> #Flood has been set to ')
		set_text(LANG, 'errflood', '*Wrong number,range is [2-99999]')

		set_text(LANG, 'gSettings', 'Settings For')
		set_text(LANG, 'sSettings', 'Settings For')
		
		set_text(LANG, 'gmuteslist', 'Mutes List For')
		set_text(LANG, 'smuteslist', 'Mutes List For')

		set_text(LANG, 'allowed', '[No | 🔓]')
		set_text(LANG, 'noAllowed', '[Yes | 🔐]')
		set_text(LANG, 'le', '[Enable]')
		set_text(LANG, 'unlm', 'Unlimited')
		set_text(LANG, 'ld', '[Disable]')
		set_text(LANG, 'noSet', '[#Not set]')
		
		set_text(LANG, 'mts', '#Seconds.')
		set_text(LANG, 'mtm', '#Minutes.')
		set_text(LANG, 'mth', '#Hours.')
		set_text(LANG, 'mtd', '#Days')
		set_text(LANG, 'mttxt', '> Mute All Stats:')

		set_text(LANG, 'cmds', 'Bot Commands')
		set_text(LANG, 'tgservices', 'Lock TgServices')
		set_text(LANG, 'links', 'Lock Links')
		set_text(LANG, 'tag', 'Lock Tag[@]')
		set_text(LANG, 'arabic', 'Lock Arabic/Persian')
		set_text(LANG, 'bots', 'Lock Bots')
		set_text(LANG, 'gifs', 'Mute Gifs')
		set_text(LANG, 'forward', 'Lock Forward')
		set_text(LANG, 'reply', 'Lock Reply')
		set_text(LANG, 'texts', 'Mute Text')
		set_text(LANG, 'emoji', 'Lock Emoji')
		set_text(LANG, 'gpwlc', 'Group Welcome')
		set_text(LANG, 'english', 'Lock English')
		set_text(LANG, 'gpcharge', 'Expire date')
		set_text(LANG, 'gpcharge2', 'days later')
		set_text(LANG, 'webpage', 'Lock WebPage')
		set_text(LANG, 'muteall', 'Mute All')
		set_text(LANG, 'hashtag', 'Lock Hashtag[#]')
		set_text(LANG, 'contact', 'Share Contact')
		set_text(LANG, 'badword', 'Lock BadWord')
		set_text(LANG, 'lockmmr', 'Lock Members')
		set_text(LANG, 'photos', 'Mute Photos')
		set_text(LANG, 'video', 'Mute Videos')
		set_text(LANG, 'audios', 'Mute Audios')
		set_text(LANG, 'kickme', 'Lock Kickme')
		set_text(LANG, 'spam', 'Lock Spam')
		set_text(LANG, 'gName', 'Change Name')
		set_text(LANG, 'flood', 'Lock Flood')
		set_text(LANG, 'language', 'Group Language')
		set_text(LANG, 'mFlood', 'Flood Sensitivity')
		set_text(LANG, 'tFlood', 'Flood Time')
		set_text(LANG, 'setphoto', 'SetPhoto')

		set_text(LANG, 'nwflrt', 'New Word Filtered!\n> ')
		set_text(LANG, 'fletlist', 'Filtered Words :\n\n')
		set_text(LANG, 'rwflrt', ' Removed From Filtered List!')
		
		set_text(LANG, 'photoSaved', '#Done\nPhoto saved!')
		set_text(LANG, 'photoFailed', 'Failed, please try again!')
		set_text(LANG, 'setPhotoAborted', 'Stopping setphoto process...')
		set_text(LANG, 'sendPhoto', 'Please, send a photo')

		set_text(LANG, 'chatSetphoto', '> #Group photo Has Been #unlocked')
		set_text(LANG, 'channelSetphoto', '> #SuperGroup photo Has Been #unlocked')
		set_text(LANG, 'notChatSetphoto', '> #Group photo Has Been #locked')
		set_text(LANG, 'notChannelSetphoto', '> #SuperGroup photo Has Been #locked')
		set_text(LANG, 'setPhotoError', '> First Unlock SetPhoto in settings!')

		set_text(LANG, 'linkSaved', 'New link set.')
		set_text(LANG, 'groupLink', 'Group Link')
		set_text(LANG, 'plssendlink', 'Please Send Group Link Now!')
		set_text(LANG, 'sGroupLink', 'Supergroup Link')
		set_text(LANG, 'noLinkSet', 'There is not link set yet. Please add one by #setlink.')
		
		set_text(LANG, 'linksp', 'BlackPlus Support Invition Link ')
		set_text(LANG, 'nolinksp', 'There is not link Set For BlackPlus Support.')

		set_text(LANG, 'chatRename', '> #Group name has been #unlocked')
		set_text(LANG, 'channelRename', '> #SuperGroup name has been #unlocked')
		set_text(LANG, 'notChatRename', '> #Group name has been #locked')
		set_text(LANG, 'notChannelRename', '> #SuperGroup name has been #locked')

		set_text(LANG, 'lockMembersT', '> #Group members has been #unlocked')
		set_text(LANG, 'lockMembersL', '> #SuperGroup members has been #unlocked')

		set_text(LANG, 'notLockMembersT', '> #Group members has been #locked')
		set_text(LANG, 'notLockMembersL', '> #SuperGroup members has been #locked')

		set_text(LANG, 'langUpdated', 'Supergroup language Set To : ')

		set_text(LANG, 'chatUpgrade', '#Done\nChat #Upgraded')
		set_text(LANG, 'notInChann', '')

		set_text(LANG, 'chatUpgrade', '#Done\nChat #Upgraded')
		set_text(LANG, 'notInChann', '')
		set_text(LANG, 'desChanged', 'Description has been set.\n\nSelect the chat again to see the changes.')
		set_text(LANG, 'desOnlyChannels', 'Only Work on SuperGroup:(')

		set_text(LANG, 'muteAll', 'Mute All Has Been Enabled And Members Can`t Talk!!')
		set_text(LANG, 'unmuteAll', 'Mute All Has Been Disabled And Members Can Talk!!')
		set_text(LANG, 'muteAllX:1', 'SuperGroup Msgs Muted For ')
		set_text(LANG, 'muteAllX:2', '#Seconds.')
		set_text(LANG, 'muteAllX:3', '#Hours.')
		set_text(LANG, 'muteAllX:4', '#Days.')
		set_text(LANG, 'up24', '#Error\nFor Mute #Daily Use> /mute all 1d')
		set_text(LANG, 'down1', '#Error\n> Use /mute all time')
		
		set_text(LANG, 'createGroup:1', 'Group')
		set_text(LANG, 'createGroup:2', 'Has been #Created.')
		set_text(LANG, 'newGroupWelcome', 'Join My Channel  @Black_CH\nDeveloper > @MehdiHS')

		-- export_gban.lua --
		set_text(LANG, 'accountsGban', 'accounts globally banned.')

		-- Cleans --
	    set_text(LANG, 'remRules', 'Supergroup #Rules Has been #Cleaned.')
		set_text(LANG, 'remLink', 'Supergroup #Link Has been #Cleaned.')
		set_text(LANG, 'remBanlist', 'Supergroup #BanList Has been #Cleaned.')
		set_text(LANG, 'remMutelist', 'Supergroup #MuteList Has been #Cleaned.')
		set_text(LANG, 'remFilterlist', 'Supergroup #FilterList Has been #Cleaned.')
		set_text(LANG, 'remModlist', 'Supergroup #Modlist Has been #Cleaned.')
	    set_text(LANG, 'remWlc', '#Welcome_Msg Has been #Cleaned.')
		set_text(LANG, 'remGcmds', '#Global Commands Has been #Cleaned.')
	    set_text(LANG, 'remGpcmds', 'Supergroup #Commands Has been #Cleaned.')
		set_text(LANG, 'remBanlist', '#Banlist Has Been #Cleaned')
		set_text(LANG, 'remGbanlist', '#Gbanlist Has Been #Cleaned')
	    set_text(LANG, 'remGmutelist', '#Gmutelist Has Been #Cleaned')
	    set_text(LANG, 'remDeleted', '#Deleted_Account Has Been #Removed From Group!')
		
		-- giverank.lua --
		set_text(LANG, 'alreadyAdmin', '> This user is #already Admin!')
		set_text(LANG, 'alreadyMod', '> This user is #already Moderator.')
		set_text(LANG, 'alreadyOwner', '> This user is #already Owner.')
		set_text(LANG, 'newAdmin', '#Done\nUser has been #Promoted as #Admin.\nUser Info:')
		set_text(LANG, 'newMod', '#Done\nUser has been #Promoted as #Modrator.\nUser Info:')
		set_text(LANG, 'newOwner', '#Done\nUser has been #Promoted as Group #Owner.\nUser Info:')
		set_text(LANG, 'nowUser', '#Done\nUser has been #Demoted :(\nUser Info:')
		set_text(LANG, 'rmvadmin', '#Done\nUser has been #removed form #Global Admins :(\nUser Info:')
		set_text(LANG, 'demOwner', '#Done\nUser has been #removed form #Owners List :(\nUser Info:')
		
		set_text(LANG, 'modList', 'Modlist')
		set_text(LANG, 'ownerList', 'Owners')
		set_text(LANG, 'adminList', 'BlackPlus Admins')
		set_text(LANG, 'modEmpty', '> This Group is Haven`t Moderator!')
		set_text(LANG, 'ownerEmpty', '> This Group is Haven`t Owner!\nSend Msg To @BlackSupport_Bot For Set Group Owners.')
		set_text(LANG, 'adminEmpty', '> BlackPlus is Haven`t Global Admin!')

		-- id.lua --
		set_text(LANG, 'user', '> ID')
		set_text(LANG, 'supergroupName', '> Supergroup Name')
		set_text(LANG, 'phts', '> Your Profile Pictures Numb')
		set_text(LANG, 'chatName', '> Group Name')
		set_text(LANG, 'supergroup', '> Supergroup ID')
		set_text(LANG, 'idfirstname', '> First Name')
		set_text(LANG, 'idlastname', '> Last Name')
	    set_text(LANG, 'idusername', '> Username')
		set_text(LANG, 'idphonenumber', '> Phone Number')
		set_text(LANG, 'iduserlink', '> Your Link')
		set_text(LANG, 'umsg', '> The number of your messages')
		
		-- moderation.lua --
		set_text(LANG, 'userUnmuted:1', 'User')
		set_text(LANG, 'userUnmuted:2', 'Unmuted.')

		set_text(LANG, 'userMuted:1', 'User')
		set_text(LANG, 'userMuted:2', 'Muted.')

		set_text(LANG, 'kickUser:1', '> ')
		set_text(LANG, 'kickUser:2', 'Just kicked From Supergroup')

		set_text(LANG, 'banUser:1', '#Done.\n')
		set_text(LANG, 'banUser:2', 'Banned.')

		set_text(LANG, 'unbanUser:1', '#Done.\n')
		set_text(LANG, 'unbanUser:2', 'Unbanned.')

		set_text(LANG, 'gbanUser:1', '> ')
		set_text(LANG, 'gbanUser:2', 'Banned for all @BIackPlus Groups/SuperGroups! (Globally banned)')

		set_text(LANG, 'ungbanUser:1', '> ')
		set_text(LANG, 'ungbanUser:2', 'Unbanned for all @BIackPlus Groups/SuperGroups! (Unglobally banned)')

		set_text(LANG, 'addUser:1', 'User')
		set_text(LANG, 'addUser:2', 'added to chat.')
		set_text(LANG, 'addUser:3', 'added to Supergroup.')

		set_text(LANG, 'kickmeBye', 'User Left The Group With #kickme Command.\nUser #Info >')

		-- plugins.lua --
		set_text(LANG, 'plugins', 'Plugins')
		set_text(LANG, 'installedPlugins', 'plugins installed.')
		set_text(LANG, 'pEnabled', 'enabled.')
		set_text(LANG, 'pDisabled', 'disabled.')

		set_text(LANG, 'isEnabled:1', 'Plugin')
		set_text(LANG, 'isEnabled:2', 'is enabled.')

		set_text(LANG, 'notExist:1', 'Plugin')
		set_text(LANG, 'notExist:2', 'does not exists.')

		set_text(LANG, 'notEnabled:1', 'Plugin')
		set_text(LANG, 'notEnabled:2', 'not enabled.')

		set_text(LANG, 'pNotExists', 'Plugin doesn\'t exists.')

		set_text(LANG, 'pDisChat:1', 'Plugin')
		set_text(LANG, 'pDisChat:2', 'disabled on this chat.')

		set_text(LANG, 'anyDisPlugin', 'There aren\'t any disabled plugins.')
		set_text(LANG, 'anyDisPluginChat', 'There aren\'t any disabled plugins for this chat.')
		set_text(LANG, 'notDisabled', 'This plugin is not disabled')

		set_text(LANG, 'enabledAgain:1', 'Plugin')
		set_text(LANG, 'enabledAgain:2', 'is enabled again')

		-- commands.lua --
		set_text(LANG, 'commandsT', '')
		set_text(LANG, 'errorNoPlug', '')

		-- rules.lua --
		set_text(LANG, 'setRules', 'Supergroup Rules Updated.')
		
		if matches[1] == 'in' then
			return '#Done'
		elseif matches[1] == 'up' then
			return '#Done'
		end
	else
		return ""
	end
end

return {
	patterns = {
		'[!/#](in) (en)$',
		'[!/#](up) (en)$'
	},
	run = run
}


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
		
		-- welcome.lua support
		set_text(LANG, 'weloff', '#Done\nWelcome <b>Disabled</b> In This Supergroup.')
		set_text(LANG, 'welon', '#Done\nWelcome <b>Enabled</b> In This Supergroup.')
		set_text(LANG, 'welnew', 'Welcome Msg Has Been <b>Saved!</b>\nWlc Text:\n\n')
		set_text(LANG, 'gwlc', '<b>Welcome Text For This Group:</b>\n\n')
		set_text(LANG, 'nogwlc', 'Welcome <b>Not</b> Seted For This Group!')

		set_text(LANG, 'allowedSpamT', '> Group <b>Spam</b> has been #unlocked.')
		set_text(LANG, 'allowedSpamL', '> SuperGroup <b>Spam</b> has been #unlocked.')
		set_text(LANG, 'notAllowedSpamT', '> Group <b>Spam</b> is #already locked.')
		set_text(LANG, 'notAllowedSpamL', '> SuperGroup <b>Spam</b> is #already locked.')

		-- Time.lua --
		set_text(LANG, 'time1', '<b>Time</b> : ')
		set_text(LANG, 'time2', 'Date <b>(iran)</b> : ')
		set_text(LANG, 'time3', 'Date <b>(Global)</b> : ')
		
		-- Me.lua --
		set_text(LANG, 'yousend', '<b>You,ve Sent</b>')
		set_text(LANG, 'gpmsgs', '<b>Messages And This Group Has</b>')
		set_text(LANG, 'msgsss', '<b>Messages</b>')

		set_text(LANG, 'longmsg', 'Send a message with more than')
		set_text(LANG, 'longmsg2', 'characters are <b>Not allowed!!</b>')
		set_text(LANG, 'longmsg3', '<i>Msg Sender Info</i>')
		set_text(LANG, 'gchar', '<i>Max Char Sensitivity</i>')
		set_text(LANG, 'charmax', '> <b>Max Character</b> Sensitivity has been set to : ')
		set_text(LANG, 'errchar', '*Wrong number,range is <b>[1000-5000]</b>')
		
		-- bot.lua --
		set_text(LANG, 'botOn', '#Bot Now #Work In This Supergroup')
		set_text(LANG, 'botOff', '#Bot Now #Not Work In This Supergroup')

		-- settings.lua --
		set_text(LANG, 'user', 'User')
		set_text(LANG, 'isFlooding', '\nSpamming <b>Not</b> Allowed Here.\n<b>Spammer Banned!!</b>')

		set_text(LANG, 'resetgp', '#Done\nGroup was <b>reseted!</b>\n- <i>Check Settings And more...</i>')
		set_text(LANG, 'linkpvsend', '#Done\nGroup Link Was Sent On <b>Your Pv</b>.')
		set_text(LANG, 'gplinkonpv', '<b>Your Group Link</b> > ') 
        set_text(LANG, 'notfwdfromblackplus', '#Error\n> Please Forward Msg From <b>BIackPlus</b> Only')
		set_text(LANG, 'owneronlygid', '#Error\n> For <b>Moderators</b> Only!')
		set_text(LANG, 'notwkinchat', '#Error\n> This Plugin Was #Not work in normal groups!')
		set_text(LANG, 'gpdetected', '<i>Search #Success</i>\n<b>Results:</b>\n\n ')
		
		set_text(LANG, 'noStickersT', '> <b>Sticker</b> posting has been <b>Locked</b>')
		set_text(LANG, 'noStickersL', '> <b>Sticker</b> posting has been <b>Locked</b>')
		set_text(LANG, 'stickersT', '> <b>Sticker</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'stickersL', '> <b>Sticker</b> posting has been <b>Unlocked</b>')
		
		set_text(LANG, 'noTgservicesT', '> <b>TGservice</b> has been <b>Unlocked</b>')
		set_text(LANG, 'noTgservicesL', '> <b>TGservice</b> has been <b>Unlocked</b>')
		set_text(LANG, 'tgservicesT', '> <b>TGservice</b> has been <b>Locked</b>')
		set_text(LANG, 'tgservicesL', '> <b>TGservice</b> has been <b>Locked</b>')
		
		set_text(LANG, 'LinksT', '> <b>Link</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'LinksL', '> <b>Link</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'noLinksT', '> <b>Link</b> posting has been <b>Locked</b>')
		set_text(LANG, 'noLinksL', '> <b>Link</b> posting has been <b>Locked</b>')

		set_text(LANG, 'TagT', '> <b>Tag</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'TagL', '> <b>Tag</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'noTagT', '> <b>Tag</b> posting has been <b>Locked</b>')
		set_text(LANG, 'noTagL', '> <b>Tag</b> posting has been <b>Locked</b>')
		
		set_text(LANG, 'CmdsT', '> <i>Bot Commands Has Been Unlocked</i>\n<b>[Now All Members Can Use Normal Commands.]</b>')
		set_text(LANG, 'CmdsL', '> <i>Bot Commands Has Been Unlocked</i>\n<b>[Now All Members Can Use Normal Commands.]</b>')
		set_text(LANG, 'noCmds', '> <i>Bot Commands Has Been Locked</i>\n<b>[Now All Members Can Use Normal Commands.]</b>')
		set_text(LANG, 'noCmdsL', '> <i>Bot Commands Has Been Locked</i>\n<b>[Now All Members Can`t Use Normal Commands.]</b>')
		
		set_text(LANG, 'webpageT', '> <b>WebLink</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'webpageL', '> <b>WebLink</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'nowebpageT', '> <b>WebLink</b> posting has been <b>Locked</b>')
		set_text(LANG, 'nowebpageL', '> <b>WebLink</b> posting has been <b>Locked</b>')
		
		set_text(LANG, 'emojiT', '> <b>Emoji</b> Has been <b>Unlocked</b>')
		set_text(LANG, 'emojiL', '> <b>Emoji</b> Has been <b>Unlocked</b>')
		set_text(LANG, 'noemojiT', '> <b>Emoji</b> Has been <b>Locked</b>')
		set_text(LANG, 'noemojiL', '> <b>Emoji</b> Has been <b>Locked</b>')
		
		set_text(LANG, 'badwordT', '> <b>Badwords</b> Has been <b>Unlocked</b>')
		set_text(LANG, 'badwordL', '> <b>Badwords</b> Has been <b>Unlocked</b>')
		set_text(LANG, 'nobadwordT', '> <b>Badwords</b> Has been <b>Locked</b')
		set_text(LANG, 'nobadwordL', '> <b>Badwords</b> Has been <b>Locked</b')
		
		set_text(LANG, 'gifsT', '> <b>Gifs</b> Has been <b>Unmuted</b>')
		set_text(LANG, 'gifsL', '> <b>Gifs</b> Has been <b>Unmuted</b>')
		set_text(LANG, 'noGifsT', '> <b>Gifs</b> Has been <b>Muted</b>')
		set_text(LANG, 'noGifsL', '> <b>Gifs</b> Has been <b>Muted</b>')
		
		set_text(LANG, 'hashtagT', '> <b>HashTag</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'hashtagL', '> <b>HashTag</b> posting has been <b>Unlocked</b>')
		set_text(LANG, 'nohashtagT', '> <b>HashTag</b> posting has been <b>Locked</b>')
		set_text(LANG, 'nohashtagL', '> <b>HashTag</b> posting has been <b>Locked</b>')
		
		set_text(LANG, 'forwardT', '> <b>Forward</b> Msg has been <b>Unlocked</b>')
		set_text(LANG, 'forwardL', '> <b>Forward</b> Msg has been <b>Unlocked</b>')
		set_text(LANG, 'noforwardT', '> <b>Forward</b> Msg has been <b>Locked</b>')
		set_text(LANG, 'noforwardL', '> <b>Forward</b> Msg has been <b>Locked</b>')

		set_text(LANG, 'replyT', '> <b>Reply</b> has been <b>Unlocked</b>')
		set_text(LANG, 'replyL', '> <b>Reply</b> has been <b>Unlocked</b>')
		set_text(LANG, 'noreplyT', '> <b>Reply</b> has been <b>Locked</b>')
		set_text(LANG, 'noreplyL', '> <b>Reply</b> has been <b>Locked</b>')
		
		set_text(LANG, 'contactT', '> <b>Contact</b> Posting Has Been <b>Unlocked</b>')
		set_text(LANG, 'contactL', '> <b>Contact</b> Posting Has Been <b>Unlocked</b>')
		set_text(LANG, 'nocontactT', '> <b>Contact</b> Posting Has Been <b>Locked</b>')
		set_text(LANG, 'nocontactL', '> <b>Contact</b> Posting Has Been <b>Locked</b>')
		
		set_text(LANG, 'textsT', '> <b>Text</b> has been <b>Muted</b>')
		set_text(LANG, 'textsL', '> <b>Text</b> has been <b>Muted</b>')
		set_text(LANG, 'notextsT', '> <b>Text</b> has been <b>Unmuted</b>')
		set_text(LANG, 'notextsL', '> <b>Text</b> has been <b>Unmuted</b>')
		
		set_text(LANG, 'photosT', '> <b>Photo</b> Has been <b>Unmuted</b>')
		set_text(LANG, 'photosL', '> <b>Photo</b> Has been <b>Unmuted</b>')
		set_text(LANG, 'noPhotosT', '> <b>Photo</b> Has been <b>Muted</b>')
		set_text(LANG, 'noPhotosL', '> <b>Photo</b> Has been <b>Muted</b>')

		set_text(LANG, 'videoT', '> <b>Video</b> Has been <b>Unmuted</b>')
		set_text(LANG, 'videoL', '> <b>Video</b> Has been <b>Unmuted</b>')
		set_text(LANG, 'novideoT', '> <b>Video</b> Has been <b>Muted</b>')
		set_text(LANG, 'novideoL', '> <b>Video</b> Has been <b>Muted</b>')
		
		set_text(LANG, 'botsT', '> <b>Bots</b> protection has been <b>Disabled</b>')
		set_text(LANG, 'botsL', '> <b>Bots</b> protection has been <b>Disabled</b>')
		set_text(LANG, 'noBotsT', '> <b>Bots</b> protection has been <b>Enabled</b>')
		set_text(LANG, 'noBotsL', '> <b>Bots</b> protection has been <b>Enabled</b>')

		set_text(LANG, 'arabicT', '> <b>Arabic/Persian</b> has been <b>Unlocked</b>')
		set_text(LANG, 'arabicL', '> <b>Arabic/Persian</b> has been <b>Unlocked</b>')
		set_text(LANG, 'noArabicT', '> <b>Arabic/Persian</b> has been <b>Locked</b>')
		set_text(LANG, 'noArabicL', '> <b>Arabic/Persian</b> has been <b>Locked</b>')

		set_text(LANG, 'englishT', '> <b>English</b> has been <b>Unlocked</b>')
		set_text(LANG, 'englishL', '> <b>English</b> has been <b>Unlocked</b>')
		set_text(LANG, 'noenglishT', '> <b>English</b> has been <b>Locked</b>')
		set_text(LANG, 'noenglishL', '> <b>English</b> has been <b>Locked</b>')
		
		set_text(LANG, 'audiosT', '> <b>Audio</b> has been <b>Unmuted</b>')
		set_text(LANG, 'audiosL', '> <b>Audio</b> has been <b>Unmuted</b>')
		set_text(LANG, 'noAudiosT', '> <b>Audio</b> has been <b>Muted</b>')
		set_text(LANG, 'noAudiosL', '> <b>Audio</b> has been <b>Muted</b>')
		
		set_text(LANG, 'gpwlcT', '> <b>Welcome Msg</b> Has Been <b>Enabled.</b>')
		set_text(LANG, 'gpwlcL', '> <b>Welcome Msg</b> Has Been <b>Enabled.</b>')
		set_text(LANG, 'nogpwlcT', '> <b>Welcome Msg</b> Has Been <b>Disabled.</b>')
		set_text(LANG, 'nogpwlcL', '> <b>Welcome Msg</b> Has Been <b>Disabled.</b>')

		set_text(LANG, 'kickmeT', '> <b>Kickme</b> has been <b>Unlocked</b>')
		set_text(LANG, 'kickmeL', '> <b>Kickme</b> has been <b>Unlocked</b>')
		set_text(LANG, 'noKickmeT', '> <b>Kickme</b> has been <b>Locked</b>')
		set_text(LANG, 'noKickmeL', '> <b>Kickme</b> has been <b>Locked</b>')

		set_text(LANG, 'floodT', '> <b>Flood</b> has been <b>Unlocked</b>')
		set_text(LANG, 'floodL', '> <b>Flood</b> has been <b>Unlocked</b>')
		set_text(LANG, 'noFloodT', '> <b>Flood</b> has been <b>Locked</b>')
		set_text(LANG, 'noFloodL', '> <b>Flood</b> has been <b>Locked</b>')

		set_text(LANG, 'floodTime', '> <b>Flood_time</b> Check has been set to ')
		set_text(LANG, 'floodMax', '> <b>Flood</b> has been set to ')
		set_text(LANG, 'errflood', '*<i>Wrong number,range is</i>  <b>[2-99999]</b>')

		set_text(LANG, 'gSettings', '<b>Settings</b> For')
		set_text(LANG, 'sSettings', '<b>Settings</b> For')
		
		set_text(LANG, 'gmuteslist', '<b>Mutes List</b> For')
		set_text(LANG, 'smuteslist', '<b>Mutes List</b> For')

		set_text(LANG, 'allowed', '<b>[Unlock]</b>')
		set_text(LANG, 'noAllowed', '<b>[Lock]</b>')
		set_text(LANG, 'alloweds', '<b>[Unmuted]</b>')
		set_text(LANG, 'noAlloweds', '<b>[Muted]</b>')
		set_text(LANG, 'le', '<b>[Enable]</b>')
		set_text(LANG, 'unlm', '<b>Unlimited</b>')
		set_text(LANG, 'ld', '<b>[Disable]</b>')
		set_text(LANG, 'noSet', '<b>[#Not set]</b>')
		
		set_text(LANG, 'mts', '<b>Seconds.</b>')
		set_text(LANG, 'mtm', '<b>Minutes.</b>')
		set_text(LANG, 'mth', '<b>Hours.</b>')
		set_text(LANG, 'mtd', '<b>Days</b>')
		set_text(LANG, 'mttxt', '> <i>Mute All Stats:</i>')

		set_text(LANG, 'cmds', '<i>Bot Commands</i>')
		set_text(LANG, 'tgservices', '<i>TgServices</i>')
		set_text(LANG, 'links', '<i>Links</i>')
		set_text(LANG, 'stickers', '<i>Stickers</i>')
		set_text(LANG, 'tag', '<i>Tag[@]</i>')
		set_text(LANG, 'arabic', '<i>Arabic/Persian</i>')
		set_text(LANG, 'bots', '<i>Bots</i>')
		set_text(LANG, 'gifs', '<i>Gifs</i>')
		set_text(LANG, 'forward', '<i>Forward</i>')
		set_text(LANG, 'reply', '<i>Reply</i>')
		set_text(LANG, 'texts', '<i>Text</i>')
		set_text(LANG, 'emoji', '<i>Emoji</i>')
		set_text(LANG, 'gpwlc', '<i>Group Welcome</i>')
		set_text(LANG, 'english', '<i>English</i>')
		set_text(LANG, 'gpcharge', '<i>Expire date</i>')
		set_text(LANG, 'gpcharge2', '<i>days later</i>')
		set_text(LANG, 'webpage', '<i>WebPage</i>')
		set_text(LANG, 'muteall', '<i>Mute All</i>')
		set_text(LANG, 'hashtag', '<i>Hashtag[#]</i>')
		set_text(LANG, 'contact', '<i>Share Contact</i>')
		set_text(LANG, 'badword', '<i>BadWord</i>')
		set_text(LANG, 'lockmmr', '<i>Members</i>')
		set_text(LANG, 'photos', '<i>Photos</i>')
		set_text(LANG, 'video', '<i>Videos</i>')
		set_text(LANG, 'audios', '<i>Audios</i>')
		set_text(LANG, 'kickme', '<i>Kickme</i>')
		set_text(LANG, 'spam', '<i>Spam</i>')
		set_text(LANG, 'gName', '<i>Change Name</i>')
		set_text(LANG, 'flood', '<i>Flood</i>')
		set_text(LANG, 'language', '<i>Group Language</i>')
		set_text(LANG, 'mFlood', '<i>Flood Sensitivity</i>')
		set_text(LANG, 'tFlood', '<i>Flood Time</i>')
		set_text(LANG, 'setphoto', '<i>SetPhoto</i>')

		set_text(LANG, 'nwflrt', 'New Word <b>Filtered!</b>\n> ')
		set_text(LANG, 'fletlist', '<b>Filtered Words</b> :\n\n')
		set_text(LANG, 'rwflrt', ' <b>Removed</b> From <b>Filtered List!</b>')
		
		set_text(LANG, 'photoSaved', '<code>Done</code>\n<b>Photo saved!</b>')
		set_text(LANG, 'photoFailed', '<code>Failed</code>, <b>please try again!</b>')
		set_text(LANG, 'setPhotoAborted', '<b>Stopping setphoto process...</b>')
		set_text(LANG, 'sendPhoto', '<b>Please, send a photo</b>')

		set_text(LANG, 'chatSetphoto', '> <b>Group photo Has Been <b>Unlocked</b>')
		set_text(LANG, 'channelSetphoto', '> <b>SuperGroup photo</b> Has Been <b>Unlocked</b>')
		set_text(LANG, 'notChatSetphoto', '> <b>Group photo</b> Has Been <b>Locked</b>')
		set_text(LANG, 'notChannelSetphoto', '> #SuperGroup <b>photo</b> Has Been <b>Locked</b>')
		set_text(LANG, 'setPhotoError', '> First <b>Unlock SetPhoto</b> in <b>settings!</b>')

		set_text(LANG, 'linkSaved', '<b>New link set.</b>')
		set_text(LANG, 'groupLink', '<b>Group Link</b>')
		set_text(LANG, 'plssendlink', '<b>Please Send Group Link Now!</b>')
		set_text(LANG, 'sGroupLink', '<b>Supergroup Link</b>')
		set_text(LANG, 'noLinkSet', 'There is not link set yet. Please add one by #setlink.')
		set_text(LANG, 'forgroupLink', '> Click To Join ')
		
		set_text(LANG, 'linksp', '..........................................................\nClick To Join BlackPlus Support!\n..........................................................')
		set_text(LANG, 'nolinksp', 'There is <b>not link Set</b> For <i>BlackPlus Support.</i>')

		set_text(LANG, 'chatRename', '> <b>Group name</b> has been <b>Unlocked</b>')
		set_text(LANG, 'channelRename', '> <b>SuperGroup name</b> has been <b>Unlocked</b>')
		set_text(LANG, 'notChatRename', '> <b>Group name</b> has been <b>Locked</b>')
		set_text(LANG, 'notChannelRename','> <b>SuperGroup name</b> has been <b>Locked</b>')

		set_text(LANG, 'lockMembersT', '> <b>Group members</b> has been <b>Unlocked</b>')
		set_text(LANG, 'lockMembersL', '> <b>SuperGroup members</b> has been <b>Unlocked</b>')
		set_text(LANG, 'notLockMembersT', '> <b>Group members</b> has been <b>Locked</b>')
		set_text(LANG, 'notLockMembersL', '> <b>SuperGroup members</b> has been <b>Locked</b>')

		set_text(LANG, 'langUpdated', 'Supergroup <b>language</b> Set To : ')

		set_text(LANG, 'chatUpgrade', '<code>Done.</code>\nChat <b>Upgraded</b>')
		set_text(LANG, 'notInChann', '')
		set_text(LANG, 'desChanged', '<b>Description has been set.</b>\n\n<code>Select the chat again to see the changes.</code>')
		set_text(LANG, 'desOnlyChannels', '<code>Only Work on SuperGroup:(</code>')

		set_text(LANG, 'muteAll', '<b>Mute All</b> Has Been <b>Enabled</b> And Members <b>Can`t Talk!!</b>')
		set_text(LANG, 'unmuteAll', '<b>Mute All</b> Has Been <b>Disabled</b> And Members <b>Can Talk!!</b>')
		set_text(LANG, 'muteAllX:1', 'SuperGroup Msgs <b>Muted</b> For ')
		set_text(LANG, 'muteAllX:2', '<b>Seconds.</b>')
		set_text(LANG, 'muteAllX:3', '<b>Hours.</b>')
		set_text(LANG, 'muteAllX:4', '<b>Days.</b>')
		set_text(LANG, 'up24', '<code>Error</code>\nFor Mute <b>Daily</b> Use> <b>/mute all 1d</b>')
		set_text(LANG, 'down1', '<code>Error</code>\n> <b>Use /mute all time</b>')
		
		set_text(LANG, 'createGroup:1', '<b>Group</b>')
		set_text(LANG, 'createGroup:2', 'Has been <b>Created.</b>')
		set_text(LANG, 'newGroupWelcome', 'Join My <b>Channel</b>  @Black_CH\n<b>Developer</b> > @MehdiHS')

		-- export_gban.lua -- 
		set_text(LANG, 'accountsGban', '<b>accounts globally banned.</b>')

		-- Cleans --
	    set_text(LANG, 'remRules', 'Supergroup <b>Rules</b> Has been <b>Cleaned</b>')
		set_text(LANG, 'remLink', 'Supergroup <b>Link</b> Has been <b>Cleaned</b>')
		set_text(LANG, 'remBanlist', 'Supergroup <b>BanList</b> Has been <b>Cleaned</b>')
		set_text(LANG, 'remMutelist', 'Supergroup <b>MuteList</b> Has been <b>Cleaned</b>')
		set_text(LANG, 'remFilterlist', 'Supergroup <b>FilterList</b> Has been <b>Cleaned</b>')
		set_text(LANG, 'remModlist', 'Supergroup <b>Modlist</b> Has been <b>Cleaned</b>')
	    set_text(LANG, 'remWlc', '<b>Welcome Msg</b> Has been <b>Cleaned</b>')
		set_text(LANG, 'remGcmds', '<b>Global Commands</b> Has been <b>Cleaned</b>')
	    set_text(LANG, 'remGpcmds', 'Supergroup <b>Commands</b> Has been <b>Cleaned</b>')
		set_text(LANG, 'remBanlist', '<b>Banlist</b> Has Been <b>Cleaned</b>')
		set_text(LANG, 'remGbanlist', '<b>Gbanlist</b> Has Been <b>Cleaned</b>')
	    set_text(LANG, 'remGmutelist', '<b>Gmutelist</b> Has Been <b>Cleaned</b>')
	    set_text(LANG, 'remDeleted', '<b>Deleted Account</b> Has Been <b>Removed</b> From Group!')
		
		-- giverank.lua --
		set_text(LANG, 'alreadyAdmin', '> This user is <b>Already Admin!</b>')
		set_text(LANG, 'alreadyMod', '> This user is <b>Already Moderator.</b>')
		set_text(LANG, 'alreadyOwner', '> This user is <b>Already Owner.</b>')
		set_text(LANG, 'newAdmin', '#Done\nUser has been #Promoted as <b>Admin.\nUser Info:</b>')
		set_text(LANG, 'newMod', '#Done\nUser has been #Promoted as <b>Modrator.\nUser Info:</b>')
		set_text(LANG, 'newOwner', '#Done\nUser has been #Promoted as <b>Group Owner.\nUser Info:</b>')
		set_text(LANG, 'nowUser', '#Done\nUser has been <b>Demoted :(\nUser Info:</b>')
		set_text(LANG, 'rmvadmin', '#Done\nUser has been <b>Removed form #Global Admins :(\nUser Info:</b>')
		set_text(LANG, 'demOwner', '#Done\nUser has been <b>Removed form #Owners List :(\nUser Info:</b>')
		
		set_text(LANG, 'modList', '<b>Modlist</b>')
		set_text(LANG, 'ownerList', '<b>Owners</b>')
		set_text(LANG, 'adminList', 'BlackPlus <b>Admins</b>')
		set_text(LANG, 'modEmpty', '> <b>This Group is Haven`t Moderator!</b>')
		set_text(LANG, 'ownerEmpty', '> <b>This Group is Haven`t Owner!\nSend Msg To @BlackSupport_Bot For Set Group Owners</b>.')
		set_text(LANG, 'adminEmpty', '> <b>BlackPlus is Haven`t Global Admin!</b>')

		-- id.lua --
		set_text(LANG, 'user', '> <b>ID</b>')
		set_text(LANG, 'supergroupName', '> <b>Supergroup Name</b>')
		set_text(LANG, 'phts', '> Your Profile Pictures Numb')
		set_text(LANG, 'chatName', '> Group Name')
		set_text(LANG, 'supergroup', '> <b>Supergroup ID</b>')
		set_text(LANG, 'idfirstname', '> First Name')
		set_text(LANG, 'idlastname', '> Last Name')
	    set_text(LANG, 'idusername', '> <b>Username</b>')
		set_text(LANG, 'idphonenumber', '> <b>Phone Number</b>')
		set_text(LANG, 'iduserlink', '> <b>Your Link</b>')
		set_text(LANG, 'umsg', '> <b>The number of your messages</b>')
		
		-- moderation.lua --
		set_text(LANG, 'userUnmuted:1', '<b>User</b>')
		set_text(LANG, 'userUnmuted:2', '<b>Unmuted.</b>')

		set_text(LANG, 'userMuted:1', '<b>User</b>')
		set_text(LANG, 'userMuted:2', '<b>Muted.</b>')

		set_text(LANG, 'kickUser:1', '> ')
		set_text(LANG, 'kickUser:2', '<b>Just kicked</b> From Supergroup')

		set_text(LANG, 'banUser:1', '<code>Done.</code>\n')
		set_text(LANG, 'banUser:2', '<b>Banned.</b>')

		set_text(LANG, 'unbanUser:1', '<code>Done.</code>\n')
		set_text(LANG, 'unbanUser:2', '<b>Unbanned.</b>')

		set_text(LANG, 'gbanUser:1', '> ')
		set_text(LANG, 'gbanUser:2', 'Banned for all <b>BIackPlus</b> Groups/SuperGroups! <b>(Globally banned)</b>')

		set_text(LANG, 'ungbanUser:1', '> ')
		set_text(LANG, 'ungbanUser:2', 'Unbanned for all <b>BIackPlus</b> Groups/SuperGroups! <b>(Unglobally banned)</b>')

		set_text(LANG, 'addUser:1', '<b>User</b>')
		set_text(LANG, 'addUser:2', '<b>added to chat.</b>')
		set_text(LANG, 'addUser:3', '<b>added to Supergroup.</b>')

		set_text(LANG, 'kickmeBye', 'User Left The Group With <b>Kickme Command.\nUser #Info ></b>')

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

		-- rules.lua --link
		set_text(LANG, 'setRules', '<b>Supergroup Rules Updated.</b>')
		
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

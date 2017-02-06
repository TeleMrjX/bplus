
local LANG = 'fa'

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
		set_text(LANG, 'cnotmod', 'شما نمیتوانید مدیر های گروه رو اخراج کنید!!')
		set_text(LANG, 'cnotadmin', 'شما نمیتوانید ادمین های ربات را گلوبال بن کنید!!')
		set_text(LANG, 'cnotmmod', 'شما نمیتوانید مدیر های گروه رو میوت کنید!!')
		set_text(LANG, 'caddmt', 'شما نمیتوانید ادمین های ربات را میوت کنید!!')
		
		-- welcome.lua floodmax
		set_text(LANG, 'weloff', 'پیام خوشامدگویی در این گروه غیرفعال شد.')
		set_text(LANG, 'welon', 'پیام خوشامد گویی فعال شد.')
		set_text(LANG, 'welnew', 'پیام خوشامد گویی ذخیره شد\nمتن پیام:\n\n')
		set_text(LANG, 'gwlc', 'پیام خوشامد گویی برای این گروه:\n\n')
		set_text(LANG, 'nogwlc', 'هیچ پیام خوشامد گیی برای این گروه تنظیم نشده است!')

		set_text(LANG, 'allowedSpamT', '> از این به بعد این گروه در مقابل اسپمینگ محافظت نمیشود.')
		set_text(LANG, 'allowedSpamL', '> از این به بعد این گروه در مقابل اسپمینگ محافظت نمیشود.')
		set_text(LANG, 'notAllowedSpamT', '> از این به بعد این گروه در مقابل اسپمینگ محافظت میشود.')
		set_text(LANG, 'notAllowedSpamL', '> از این به بعد این گروه در مقابل اسپمینگ محافظت میشود.')

		-- Time.lua --
		set_text(LANG, 'time1', 'زمان : ')
		set_text(LANG, 'time2', 'تاریخ شمسی : ')
		set_text(LANG, 'time3', 'تاریخ میلادی : ')
		
		set_text(LANG, 'yousend', 'تعداد پیام های ارسال شده توسط شما')
		set_text(LANG, 'gpmsgs', 'پیام و تعداد پیام های ارسال شده در گروه')
		set_text(LANG, 'msgsss', 'پیام')
		
		set_text(LANG, 'longmsg', 'ارسال پیام با')
		set_text(LANG, 'longmsg2', 'حرف و بیشتر مجاز نیست!\nپیام پاک شد.')
		set_text(LANG, 'longmsg3', 'مشخصات ارسال کننده پبام')
		set_text(LANG, 'gchar', 'حساسیت به تعداد حروف جمله')
		set_text(LANG, 'charmax', 'بیشترین حروف مجاز در جمله تغییر کرد به : ')
		set_text(LANG, 'errchar', 'خطا!\n این مقدار باید بیشتر از 1000 باشد.')
		
		-- bot.lua --
		set_text(LANG, 'botOn', 'ربات روشن شد')
		set_text(LANG, 'botOff', 'ربات در این گروه غیر فعال شد')

		-- settings.lua --
		set_text(LANG, 'user', 'کاربر')
		set_text(LANG, 'isFlooding', '\nاسپم کردن این گروه مجاز نیست\nکاربر بن شد.')

		set_text(LANG, 'resetgp', 'تمامی اطلاعات گروه حذف شد\nبرای اطلاعات بیشتر تنظیمات و غیره را چک کنید.')
		set_text(LANG, 'linkpvsend', 'لینک گروه در پیوی شما ارسال شد.')
		set_text(LANG, 'gplinkonpv', 'لینک گروه شما : ') 
        set_text(LANG, 'notfwdfromblackplus', 'خطا\nاین پیام فقط در صورت فوروارد شدن از بلک پلاس معتبر است.')
		set_text(LANG, 'owneronlygid', 'خطا\nفقط مدیر های گروه قادر به استفاده از این دستور میباشند.')
		set_text(LANG, 'notwkinchat', 'خطا\nاین قابلیت در گروه های معمولی غیر فعال است. ')
		set_text(LANG, 'gpdetected', 'جستوجو با موفقیت انجام شد.\nنتایج:\n\n ')
		
		set_text(LANG, 'noStickersT', '> ارسال استیکر قفل شد')
		set_text(LANG, 'noStickersL', '> ارسال استیکر قفل شد')
		set_text(LANG, 'stickersT', '> ارسال استیکر آزاد شد.')
		set_text(LANG, 'stickersL', '> ارسال استیکر آزاد شد.')
		
		set_text(LANG, 'noTgservicesT', '> پیام ورود و خروج از این به بعد پاک نمیشود.')
		set_text(LANG, 'noTgservicesL', '> پیام ورود و خروج از این به بعد پاک نمیشود.')
		set_text(LANG, 'tgservicesT', '> پیام ورود و خروج از این به بعد پاک میشود.')
		set_text(LANG, 'tgservicesL', '> پیام ورود و خروج از این به بعد پاک میشود.')
		
		set_text(LANG, 'LinksT', '> ارسال لینک در گروه آزاد شد.')
		set_text(LANG, 'LinksL', '> ارسال لینک در گروه آزاد شد.')
		set_text(LANG, 'noLinksT', '> ارسال لینک در گروه قفل شد.')
		set_text(LANG, 'noLinksL', '> ارسال لینک در گروه قفل شد.')

		set_text(LANG, 'TagT', '> ارسال تگ آزاد شد.')
		set_text(LANG, 'TagL', '> ارسال تگ آزاد شد.')
		set_text(LANG, 'noTagT', '> ارسال تگ قفل شد.')
		set_text(LANG, 'noTagL', '> ارسال تگ قفل شد.')
		
		set_text(LANG, 'CmdsT', '> استفاده از دستورات معمولی ربات برای کاربران عادی آزاد شد.')
		set_text(LANG, 'CmdsL', '> استفاده از دستورات معمولی ربات برای کاربران عادی آزاد شد.')
		set_text(LANG, 'noCmds', '> استفاده از دستورات معمولی ربات برای کاربران عادی قفل شد.')
		set_text(LANG, 'noCmdsL', '> استفاده از دستورات معمولی ربات برای کاربران عادی قفل شد.')
		
		set_text(LANG, 'webpageT', '> ارسال لینک سایت آزاد شد.')
		set_text(LANG, 'webpageL', '> ارسال لینک سایت آزاد شد.')
		set_text(LANG, 'nowebpageT', '> ارسال لینک سایت قفل شد.')
		set_text(LANG, 'nowebpageL', '> ارسال لینک سایت قفل شد.')
		
		set_text(LANG, 'emojiT', '> ارسال اموجی آزاد شد.')
		set_text(LANG, 'emojiL', '> ارسال اموجی آزاد شد.')
		set_text(LANG, 'noemojiT', '> ارسال اموجی قفل شد.')
		set_text(LANG, 'noemojiL', '> ارسال اموجی قفل شد.')
		
		set_text(LANG, 'badwordT', '> استفاده از فحش آزاد شد.')
		set_text(LANG, 'badwordL', '> استفاده از فحش آزاد شد.')
		set_text(LANG, 'nobadwordT', 'استفاده از فحش قفل شد.')
		set_text(LANG, 'nobadwordL', 'استفاده از فحش قفل شد.')
		
		set_text(LANG, 'gifsT', '> گیف آنمیوت شد.')
		set_text(LANG, 'gifsL', '> گیف آنمیوت شد.')
		set_text(LANG, 'noGifsT', '> گیف میوت شد.')
		set_text(LANG, 'noGifsL', '> گیف میوت شد.')
		
		set_text(LANG, 'contactT', '> شیر کانتکت آزاد')
		set_text(LANG, 'contactL', '> شیر کانتکت آزاد')
		set_text(LANG, 'nocontactT', '> شیر کانتکت قفل شد')
		set_text(LANG, 'nocontactL', '> شیر کانتکت قفل شد')
		
		set_text(LANG, 'hashtagT', '> ارسال هشتگ آزاد شد.')
		set_text(LANG, 'hashtagL', '> ارسال هشتگ آزاد شد.')
		set_text(LANG, 'nohashtagT', '> ارسال هشتگ قفل شد.')
		set_text(LANG, 'nohashtagL', '> ارسال هشتگ قفل شد.')
		
		set_text(LANG, 'forwardT', '> فروارد کردن پیام آزاد شد.')
		set_text(LANG, 'forwardL', '> فروارد کردن پیام آزاد شد.')
		set_text(LANG, 'noforwardT', '> فروارد کردن پیام قفل شد.')
		set_text(LANG, 'noforwardL', '> فروارد کردن پیام قفل شد.')

		set_text(LANG, 'replyT', '> ریپلی کردن پیام آزاد شد.')
		set_text(LANG, 'replyL', '> ریپلی کردن پیام آزاد شد.')
		set_text(LANG, 'noreplyT', '> ریپلی کردن پیام قفل شد.')
		set_text(LANG, 'noreplyL', '> ریپلی کردن پیام قفل شد.')
		
		set_text(LANG, 'textsT', '> ارسال متن آنمیوت شد')
		set_text(LANG, 'textsL', '> ارسال متن آنمیوت شد')
		set_text(LANG, 'notextsT', '> ارسال متن میوت شد')
		set_text(LANG, 'notextsL', '> ارسال متن میوت شد')
		
		set_text(LANG, 'photosT', '> عکس آنمیوت شد.')
		set_text(LANG, 'photosL', '> عکس آنمیوت شد.')
		set_text(LANG, 'noPhotosT', '> عکس میوت شد.')
		set_text(LANG, 'noPhotosL', '> عکس میوت شد.')

		set_text(LANG, 'videoT', '> فیلم آنمیوت شد.')
		set_text(LANG, 'videoL', '> فیلم آنمیوت شد.')
		set_text(LANG, 'novideoT', '> فیلم میوت شد.')
		set_text(LANG, 'novideoL', '> فیلم میوت شد.')
		
		set_text(LANG, 'botsT', '> ادد کردن ربات در گروه آزاد شد.')
		set_text(LANG, 'botsL', '> ادد کردن ربات در گروه آزاد شد.')
		set_text(LANG, 'noBotsT', '> ادد کردن ربات در گروه قفل شد.')
		set_text(LANG, 'noBotsL', '> ادد کردن ربات در گروه قفل شد.')

		set_text(LANG, 'arabicT', '> استفاده از زبان فارسی و عربی آزاد شد.')
		set_text(LANG, 'arabicL', '> استفاده از زبان فارسی و عربی آزاد شد.')
		set_text(LANG, 'noArabicT', '> استفاده از زبان فارسی و عربی قفل شد.')
		set_text(LANG, 'noArabicL', '> استفاده از زبان فارسی و عربی قفل شد.')

		set_text(LANG, 'englishT', '> استفاده از زبان انگلیسی آزاد شد.')
		set_text(LANG, 'englishL', '> استفاده از زبان انگلیسی آزاد شد.')
		set_text(LANG, 'noenglishT', '> استفاده از زبان انگلیسی قفل شد.')
		set_text(LANG, 'noenglishL', '> استفاده از زبان انگلیسی قفل شد.')
		
		set_text(LANG, 'audiosT', '> ارسال صدا و وویس آنمیوت شد.')
		set_text(LANG, 'audiosL', '> ارسال صدا و وویس آنمیوت شد.')
		set_text(LANG, 'noAudiosT', '> ارسال صدا و وویس میوت شد.')
		set_text(LANG, 'noAudiosL', '> ارسال صدا و وویس میوت شد.')

		set_text(LANG, 'kickmeT', '> آزاد شد kickme استفاده از دستور')
		set_text(LANG, 'kickmeL', '> آزاد شد kickme استفاده از دستور')
		set_text(LANG, 'noKickmeT', '> قفل شد kickme استفاده از دستور')
		set_text(LANG, 'noKickmeL', '> قفل شد kickme استفاده از دستور')

		set_text(LANG, 'floodT', '> از این به بعد اسپمینگ در این گروه محافظت نمیشود')
		set_text(LANG, 'floodL', '> از این به بعد اسپمینگ در این گروه محافظت نمیشود')
		set_text(LANG, 'noFloodT', '> از این به بعد اسپمینگ در این گروه محافظت میشود')
		set_text(LANG, 'noFloodL', '> از این به بعد اسپمینگ در این گروه محافظت میشود')

		set_text(LANG, 'floodTime', '> زمان برسی اسپم ها در این چت تنظیم شد به هر ')
		set_text(LANG, 'floodMax', '> حداکثر حساسیت سیستم آنتی اسپم تنظیم شد به ')
        set_text(LANG, 'errflood', 'خطا!\n این مقدار باید بیشتر از 2 باشد.')
		
		set_text(LANG, 'gSettings', ':تنظیمات گروه')
		set_text(LANG, 'sSettings', ':تنظیمات سوپرگروه')
		
		set_text(LANG, 'gmuteslist', ':لیست میوت ها')
		set_text(LANG, 'smuteslist', ':لیست میوت ها')

		set_text(LANG, 'allowed', '[آزاد | 🔓]')
		set_text(LANG, 'noAllowed', '[قفل | 🔐]')
		set_text(LANG, 'alloweds', '[آزاد | 🔓]')
		set_text(LANG, 'noAlloweds', '[قفل | 🔐]')
		set_text(LANG, 'unlm', 'نامحدود')
		set_text(LANG, 'le', '[فعال]')
		set_text(LANG, 'ld', '[غیر فعال]')
		set_text(LANG, 'noSet', 'تنظیم نشده')
		
		set_text(LANG, 'mts', 'ثانیه')
		set_text(LANG, 'mtm', 'دقیقه')
		set_text(LANG, 'mth', 'ساعت')
		set_text(LANG, 'mtd', 'روز')
		set_text(LANG, 'mttxt', 'مدت زمان میوت ماندن سوپرگروه:')

		set_text(LANG, 'stickers', 'ارسال استیکر')
		set_text(LANG, 'cmds', 'دستور های ربات')
		set_text(LANG, 'tgservices', 'پیام ورود و خروج')
		set_text(LANG, 'links', 'لینک های تلگرام')
		set_text(LANG, 'tag', '[@]تگ')
		set_text(LANG, 'arabic', 'فارسی و عربی')
		set_text(LANG, 'bots', 'اضافه کردن ربات')
		set_text(LANG, 'gifs', 'گیف ها')
		set_text(LANG, 'forward', 'فروارد کردن پیام')
		set_text(LANG, 'texts', 'نوشته ها')
		set_text(LANG, 'reply', 'ریپلی کردن پیام')
		set_text(LANG, 'emoji', 'اموجی')
		set_text(LANG, 'gpwlc', 'پیام خوشامد گویی')
		set_text(LANG, 'english', 'انگلیسی')
		set_text(LANG, 'webpage', 'لینک سایت')
		set_text(LANG, 'gpcharge', 'تاریخ انقضا گروه')
		set_text(LANG, 'gpcharge2', 'روز دیگر.')
		set_text(LANG, 'lockmmr', 'ورود افراد')
		set_text(LANG, 'muteall', 'میوت آل')
		set_text(LANG, 'contact', 'شیر کانتکت')
		set_text(LANG, 'hashtag', '[#]هشتگ')
		set_text(LANG, 'badword', 'فحش')
		set_text(LANG, 'photos', 'عکس ها')
		set_text(LANG, 'video', 'فیلم ها')
		set_text(LANG, 'audios', 'وویس و صدا ها')
		set_text(LANG, 'kickme', ' استفاده از /kickme')
		set_text(LANG, 'spam', 'اسپم لینک')
		set_text(LANG, 'gName', 'اسم گروه')
		set_text(LANG, 'flood', 'اسپم')
		set_text(LANG, 'language', 'زیان گروه')
		set_text(LANG, 'mFlood', 'حساسیت آنتی اسپم')
		set_text(LANG, 'tFlood', 'زمان بررسی اسپم ها')
		set_text(LANG, 'setphoto', 'عکس گروه')

		set_text(LANG, 'nwflrt', '> کلمه جدید فیلتر شد\n\n')
		set_text(LANG, 'fletlist', 'کلمات فیلتر شده :\n\n')
		set_text(LANG, 'rwflrt', ' از لیست کلمات فیلتر شده حذف شد')
		
		set_text(LANG, 'photoSaved', 'عکس ذخیره شد')
		set_text(LANG, 'photoFailed', 'دوباره تلاش کنید')
		set_text(LANG, 'setPhotoAborted', '')
		set_text(LANG, 'sendPhoto', 'لطفا عکس را ارسال کنید')

		set_text(LANG, 'chatSetphoto', '> تغییر عکس گروه آزاد شد')
		set_text(LANG, 'channelSetphoto', '> تغییر عکس گروه آزاد شد')
		set_text(LANG, 'notChatSetphoto', '> تغییر عکس گروه قفل شد')
		set_text(LANG, 'notChannelSetphoto', '> تغییر عکس گروه قفل شد')
		set_text(LANG, 'setPhotoError', '> ابتدا تغییر عکس را از ستینگ آزاد کنید')

		set_text(LANG, 'linkSaved', 'لینک جدید ذخیره شد')
		set_text(LANG, 'groupLink', 'لینک گروه')
		set_text(LANG, 'plssendlink', 'لطفا لینک گروه را ارسال کنید!')
		set_text(LANG, 'sGroupLink', 'لینک سوپرگروه')
		set_text(LANG, 'forgroupLink', 'لینک گروه ')
		set_text(LANG, 'noLinkSet', 'هیچ لینکی تنظیم نشده است. لطفا با دستور زیر لینکتان را در ربات ذخیره کنید\n/setlink [link]')

		set_text(LANG, 'linksp', ' ..........................................................\nبرای ورود به گروه پشتبیانی روی متن کلیک کنید!\n..........................................................')
		set_text(LANG, 'nolinksp', 'در حال حاضر هیچ لینکی به عنوان لینک گروه پشتیبانی ثبت نشده')

		set_text(LANG, 'chatRename', '> تغییر اسم گروه آزاد شد')
		set_text(LANG, 'channelRename', '> تغییر اسم گروه آزاد شد')
		set_text(LANG, 'notChatRename', '> تغییر اسم گروه قفل شد')
		set_text(LANG, 'notChannelRename', '> تغییر اسم گروه قفل شد')

		set_text(LANG, 'lockMembersT', '> عضو گیری آزاد شد')
		set_text(LANG, 'lockMembersL', '> عضو گیری آزاد شد')

		set_text(LANG, 'notLockMembersT', '> عضو گیری قفل شد')
		set_text(LANG, 'notLockMembersL', '> عضو گیری قفل شد')

		set_text(LANG, 'langUpdated', 'زبان گروه تغییر کرد به : ')

		set_text(LANG, 'chatUpgrade', 'گروه سوپرگروه شد')
		set_text(LANG, 'notInChann', '')

		set_text(LANG, 'chatUpgrade', 'گروه سوپرگروه شد')
		set_text(LANG, 'notInChann', '')
		set_text(LANG, 'desChanged', 'اطلاعات گروه تنظیم شد')
		set_text(LANG, 'desOnlyChannels', '):فقط تو سوپرگروه کار میکنه')

		set_text(LANG, 'muteAll', 'قفل همه ی پیام ها فعال شد و کاربران نمیتوانند صحبت کنند!!')
		set_text(LANG, 'unmuteAll', 'قفل همه ی پیام هاغیر فعال شد و کاربران میتوانند صحبت کنند!!')
		set_text(LANG, 'muteAllX:1', 'همه ی پبام ها قفل شد و کاربران تا ')
		set_text(LANG, 'muteAllX:2', 'ثانیه نمیتوانند صحبت کنند!!')
		set_text(LANG, 'muteAllX:3', 'ساعت نمیتوانند صحبت کنند!!')
		set_text(LANG, 'muteAllX:4', 'روز نمیتوانند صحبت کنند!!')
		set_text(LANG, 'up24', 'خطا\nبرای میوت کردن روزانه از دستور زیر استفاده کنید\n /mute all 1d')
		set_text(LANG, 'down1', 'خطا\nبرای میوت کردن با زمان زیر 1ساعت از دستور زیر استفاده کنید\n  /mute all time')
		

		set_text(LANG, 'createGroup:1', 'گروه')
		set_text(LANG, 'createGroup:2', 'ساخته شد')
		set_text(LANG, 'newGroupWelcome', 'در کانال ما عضو شوید  @Black_CH\nسازنده > @MehdiHS')

		-- export_gban.lua --
		set_text(LANG, 'accountsGban', 'اکانت از همه ی گروه ها بن شده')

		-- Cleans --
	    set_text(LANG, 'remRules', 'قوانین گروه #حذف شد.')
		set_text(LANG, 'remLink', 'لینک گروه #حذف شد')
		set_text(LANG, 'remBanlist', 'لیست افراد #بن شده خالی شد.')
		set_text(LANG, 'remMutelist', 'لیست افراد #میوت شده خالی شد')
		set_text(LANG, 'remFilterlist', 'لیست کلمات #فیلتر شده خالی شد')
		set_text(LANG, 'remWlc', 'پیام خوشامد گویی حذف شد.')
		set_text(LANG, 'remGcmds', 'دستورات تنظیم شده ربات #حذف شد.')
	    set_text(LANG, 'remGpcmds', 'دستورات تنظیم شده برای این گروه #حذف شد.')
		set_text(LANG, 'remBanlist', 'لیست افراد بن شده #خالی شد')
		set_text(LANG, 'remGbanlist', 'لیست افراد گلوبال بن شده #خالی شد')
	    set_text(LANG, 'remGmutelist', 'لیست افراد گلوبال میوت شده #خالی شد')
		set_text(LANG, 'remDeleted', 'کاربر #دیلیت_اکانت شده از گروه حذف شد!')
		
		-- giverank.lua --
		set_text(LANG, 'alreadyAdmin', '> این کاربر از قبل #ادمین است')
		set_text(LANG, 'alreadyMod', '> این کاربر از قبل مدیر #گروه است')
		set_text(LANG, 'alreadyOwner', '> این کاربر از قبل در لیست #خریداران گروه است.')

		set_text(LANG, 'newAdmin', 'کاربر به مقام #ادمین ارتقا یافت\nاطلاعات کاربر ')
		set_text(LANG, 'newMod', 'کاربر به مدیر #گروه ارتقا یافت\nاطلاعات کاربر')
		set_text(LANG, 'newOwner', 'کاربر به مقام اونر گروه ارتقا یافت\nاطلاعات کاربر:')
		set_text(LANG, 'nowUser', 'کاربر از لیست مدیران گروه حذف شد\nاطلاعات کاربر:')
		set_text(LANG, 'rmvadmin', 'کاربر از لیست ادمین های ربات حذف شد\nاطلاعات کاربر:')
		set_text(LANG, 'demOwner', 'کابر از لیست اونر های گروه حذف شد\nاطلاعات کاریر:')
		
		set_text(LANG, 'modList', 'مدیران گروه')
		set_text(LANG, 'ownerList', 'مدیر های اصلی گروه')
		set_text(LANG, 'adminList', 'مدیران بلک پلاس')
		set_text(LANG, 'modEmpty', '> در این گروه مدیری وجود ندارد')
		set_text(LANG, 'ownerEmpty', 'در این گروه هیچ صاحب گروهی یافت نشد\nبرای تعیین صاحب اصلی گروه به ربات زیر پیام دهید\n@BlackSupport_Bot')
		set_text(LANG, 'adminEmpty', 'بلک پلاس ادمینی ندارد')

		-- id.lua --
		set_text(LANG, 'user', '> ایدی شما')
		set_text(LANG, 'phts', '> تعداد عکس های پروفایل شما')
		set_text(LANG, 'supergroupName', '> اسم سوپر گروه')
		set_text(LANG, 'chatName', '> اسم گروه')
		set_text(LANG, 'supergroup', '> ایدی گروه')
		set_text(LANG, 'idfirstname', '> اسم کوچک')
		set_text(LANG, 'idlastname', '> فامیلی')
	    set_text(LANG, 'idusername', '> آیدی')
		set_text(LANG, 'idphonenumber', '> شماره')
		set_text(LANG, 'iduserlink', '> لینک شما')
		set_text(LANG, 'umsg', '> تعداد پیام های ارسال شده')
		
		-- moderation.lua --
		set_text(LANG, 'userUnmuted:1', 'کابر')
		set_text(LANG, 'userUnmuted:2', 'آنمیوت شد')

		set_text(LANG, 'userMuted:1', 'کاربر')
		set_text(LANG, 'userMuted:2', 'میوت شد')

		set_text(LANG, 'kickUser:1', '> ')
		set_text(LANG, 'kickUser:2', 'از گروه #کیک شد')

		set_text(LANG, 'banUser:1', '> ')
		set_text(LANG, 'banUser:2', 'از گروه #بن شد')

		set_text(LANG, 'unbanUser:1', '> ')
		set_text(LANG, 'unbanUser:2', 'از گروه #آنبن شد')

		set_text(LANG, 'gbanUser:1', '> ')
		set_text(LANG, 'gbanUser:2', 'از همه ی گروه های بلک پلاس بن شد')

		set_text(LANG, 'ungbanUser:1', '> ')
		set_text(LANG, 'ungbanUser:2', 'از همه ی گروه های بلک پلاس آنبن شد')

		set_text(LANG, 'addUser:1', 'کاربر')
		set_text(LANG, 'addUser:2', 'در گروه ادد شد')
		set_text(LANG, 'addUser:3', 'در گروه ادد شد')

		set_text(LANG, 'kickmeBye', 'کاریر با دستور /kickme از گروه خارج شد!\nاطلاعات کاربر: ')

		-- plugins.lua --
		set_text(LANG, 'plugins', 'پلاگین')
		set_text(LANG, 'installedPlugins', 'پلاگین های نصب شده')
		set_text(LANG, 'pEnabled', 'فعال')
		set_text(LANG, 'pDisabled', 'غیر فعال')

		set_text(LANG, 'isEnabled:1', 'پلاگین')
		set_text(LANG, 'isEnabled:2', 'فعال شد')

		set_text(LANG, 'notExist:1', 'پلاگین')
		set_text(LANG, 'notExist:2', 'جود ندارد')

		set_text(LANG, 'notEnabled:1', 'پلاگین')
		set_text(LANG, 'notEnabled:2', 'فعال نیست')

		set_text(LANG, 'pNotExists', 'پلاگینی با این نام وجود ندارد')

		set_text(LANG, 'pDisChat:1', 'پلاگین')
		set_text(LANG, 'pDisChat:2', 'در این گروه غیر فعال شد')

		set_text(LANG, 'anyDisPlugin', '')
		set_text(LANG, 'anyDisPluginChat', '')
		set_text(LANG, 'notDisabled', 'این پلاگین غیر فعال نیست')

		set_text(LANG, 'enabledAgain:1', 'پلاگین')
		set_text(LANG, 'enabledAgain:2', 'دوباره فعال شد')

		-- commands.lua --
		set_text(LANG, 'commandsT', '')
		set_text(LANG, 'errorNoPlug', '')

		-- rules.lua --
		set_text(LANG, 'setRules', 'قوانین گروه آپدیت شد')
		
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
		'[!/#](in) (fa)$',
		'[!/#](up) (fa)$'
	},
	run = run
}

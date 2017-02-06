local function tosticker(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = 'source/dl/'..msg.from.peer_id..'.webp'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    send_document(get_receiver(msg), file, ok_cb, false)
    redis:del("photo:sticker")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function toimage(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local photofile = 'source/dl/'..msg.from.peer_id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, photofile)
    print('File moved to:', file)
    send_photo(get_receiver(msg), photofile, ok_cb, false)
    redis:del("sticker:photo")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function topng(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local pngfile = 'source/dl/'..msg.from.peer_id..'.png'
    print('File downloaded to:', result)
    os.rename(result, pngfile)
    print('File moved to:', file)
    send_document(get_receiver(msg), pngfile, ok_cb, false)
    redis:del("sticker:photo")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, please try again!', ok_cb, false)
  end
end
local function run(msg, matches)
if msg.to.type == 'chat' or msg.to.type == 'channel' then
        local cmds = 'cmds:'..msg.to.id
    if redis:get(cmds) and not permissions(msg.from.id, msg.to.id, "settings") then 
	  return
		else
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if msg.reply_id then
      	if msg.to.type == 'photo' and redis:get("photo:sticker") then
      		if redis:set("photo:sticker", "waiting") then
      	elseif msg.to.type == 'document' and redis:get("sticker:photo") then
      		if redis:set("sticker:photo", "waiting") then
      		end
  	end
  	end
      if matches[2] == "sticker" then
    	redis:get("photo:sticker")  
        load_photo(msg.reply_id, tosticker, msg)
        return
	end
	if matches[2] == "file" then
    	redis:get("photo:sticker")  
        load_document(msg.reply_id, topng, msg)
	return reply_msg(msg.id, 'شما میتوانید با ارسال کردن فایل زیر به @Stickers پک استیکر خودتون رو بسازید',ok_cb,false)
        end
     if matches[2] == "photo" then
    	redis:get("sticker:photo")  
        load_document(msg.reply_id, toimage, msg)
     return
    end
end
end
end
end
return { 
   patterns = {
	"^([#!/])(sticker)$",
	"^([#!/])(file)$",
	"^([#!/])(photo)$",
	"%[(photo)%]",
	"%[(document)%]",
       },
   run = run
}
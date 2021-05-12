-- /**
--  * 图片裁剪服务，用法如下：http://192.168.10.10/1111.jpg_100x100
--  * 该服务会在指定的thumbPath生成裁剪后的小图片，需要配置crontab定时删除，
--  * 该命令为清除60天前没有被访问过的文件：find YOUR_CACHE_DIR -atime +60 -type f -delete
--  * @barbery
--  */
local width, height, path, ext, thumbPath, filename =
  ngx.var.width, ngx.var.height, ngx.var.path, ngx.var.ext, ngx.var.thumb_path, ngx.var.filename

local images_dir = "/www/dfs/data"

local function return_not_found(msg)
  ngx.status = ngx.HTTP_NOT_FOUND
  ngx.header["Content-type"] = "text/html"
  ngx.say(msg or "not found")
  ngx.exit(0)
end

-- 避免逃逸目录搜索
path = string.gsub(path, "%.%.", ".")
path = string.gsub(path, "/group%d+/M%d+", "")

-- http://192.168.10.10/1111.jpg_100x100
local source_fname = images_dir .. path
local size = width .. "x" .. height

-- return_not_found(thumbPath .. "/" .. filename .. "_" .. size)

ngx.log(ngx.STDERR, ngx.var.request_uri)
ngx.log(ngx.STDERR, thumbPath .. path, "  ", width .. "x" .. height)
ngx.log(ngx.STDERR, "sourceName:" .. source_fname)
-- make sure the file exists
local file = io.open(source_fname)

if not file then
  ngx.log(ngx.STDERR, "not file:" .. ngx.var.path)
  -- 兼容处理压缩的小文件
  ngx.exec(ngx.var.path)
  ngx.exit(0)
end

file:close()

-- resize the image
local magick = require("magick.gmwand")
magick.thumb(source_fname, size, thumbPath .. "/" .. filename .. "." .. ext .. "_" .. size)

ngx.log(ngx.STDERR, "magick.thumb:")
ngx.exec(ngx.var.request_uri)

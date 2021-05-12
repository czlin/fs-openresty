local cjson = require "cjson"

ngx.header["Content-Type"] = "application/json"

local function getFile(file_name)
  local f = assert(io.open(file_name, 'r'))
  local string = f:read("*all")
  f:close()
  return string
end

local function get_boundary()
  ngx.req.read_body()
  local data = ngx.req.get_body_data()
  if nil == data then
      local file_name = ngx.req.get_body_file()
      ngx.log(ngx.ERR, ">> temp file: ", file_name)
      if file_name then
          data = getFile(file_name)
      end
  end
  return data;
end

local function save(self, chunk_size, max_line_size)
  local boundary = get_boundary()
  local name = ngx.var.filename
  local store_dir = ngx.var.store_dir

  local file, err = io.open(store_dir..name, "w")
  if nil == file then
      ngx.log(ngx.ERR, "open "..name.." faild,", err)
      return nil, err
  else 
      local result, error = file:write(boundary)
      if nil == result then
          ngx.log(ngx.ERR, "write "..name.." faild", error)
          return nil, error
      end
      file:close()
  end
  return name
end

local name, err = save()
local res = {}

if name then
  res["content-name"] = name
  res["status"] = "ok"
else
  res["status"] = "faild"
end

local jsonData = cjson.encode(res)
ngx.say(jsonData)

local lfs = require "lfs"

local function exists(path)
  return type(lfs.attributes(path)) == "table" -- exists
end

function maybetrim(a)
  if type(a) ~= "string" then
    error("can only maybetrim strings")
  else
    if a:match("/$") then
      return a:sub(0, a:len() - 1)
    else
      return a
    end
  end
end

local function join(a, ...)
  if a == nil then
    return ""
  else
    local next = join(...)
    if next:len() > 0 then
      return maybetrim(a) .. "/" .. next
    else
      return maybetrim(a)
    end
  end
end

local function mkdirs(a, b, ...)
  if a == nil then
    return
  end
  if not exists(a) then
    lfs.mkdir(a)
  end
  if b == nil then
    return
  end
  return mkdirs(join(a,b),...)
end

local function readall(path)
  local file = io.open(path, "r")
  if not file then
    error("File does not exist")
  end
  local content = file:read "*a"
  file:close()
  return content
end

local function writefile(path, content)
  local file = io.open(path, "w")
  file:write(content)
  return file:close()
end

return {
  join = join,
  exists = exists,
  mkdirs = mkdirs,
  readall = readall,
  writefile = writefile,
}

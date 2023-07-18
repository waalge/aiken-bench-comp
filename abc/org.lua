local lfs = require "lfs"
local p = require "paths"

local function solutionsdir(path)
  return p.join(path, "lib", "bench")
end

local function templatesdir(path)
  return p.join(path, "templates")
end

local function validatorsdir(path)
  return p.join(path, "validators")
end

local function testpath(path, challenge, testname)
  return p.join(templatesdir(path), challenge, testname .. ".ak")
end

local function outpath(path, challenge, testname, user)
  return p.join(validatorsdir(path), challenge, testname, user .. ".ak")
end


local function getaikenfiles(path)
  if not p.exists(path) then
    error("Bad file path")
  else
    local files = {}
    local ii = 1
    for file in lfs.dir(path) do
      if file:match".ak$" and file ~= "_.ak" then
        files[ii] = file:sub(0, file:len() - 3)
        ii = ii + 1
      end
    end
    return files
  end
end

local function getaikendir(path)
  local subdirs = {}
  if not p.exists(path) then
    error("Bad dir path")
  else
    for subdir in lfs.dir(path) do
      if subdir ~= "." and subdir ~= ".." then
        local f = p.join(path, subdir)
        local attr = lfs.attributes (f)
        assert (type(attr) == "table")
        if attr.mode == "directory" then
          subdirs[subdir] = getaikenfiles(f)
        end
      end
    end
    return subdirs
  end
end

local function getsolutions(path)
  return getaikendir(solutionsdir(path))
end

local function gettests(path)
    return getaikendir(templatesdir(path))
end

local function readtest(root, challenge, testname)
  return p.readall(testpath(root, challenge, testname))
end

local function writetest(root, challenge, testname, user, test)
  p.mkdirs(validatorsdir(root), challenge, testname)
  return p.writefile(outpath(root, challenge, testname, user), test)
end

return {
  getsolutions = getsolutions,
  gettests = gettests,
  readtest = readtest,
  writetest = writetest,
  validatorsdir = validatorsdir,
}
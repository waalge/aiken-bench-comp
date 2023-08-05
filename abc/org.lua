local lfs = require "lfs"
local p = require "paths"
local pretty = require "pretty"

local function solutionsdir(path)
  return p.join(path, "lib", "bench")
end

local function testsdir(path)
  return p.join(path, "tests")
end

local function validatorsdir(path)
  return p.join(path, "validators")
end

local function testpath(root, group, testmod)
  return p.join(testsdir(root), group, testmod .. ".ak")
end

local function solutionpath(solution)
  local x = p.join(solution.user, solution.group)
  if solution.version ~= nil then
    return p.join( x,  solution.version)
  end
  return x
end

local function outpath(root, group, testmod, solution)
  local x = p.join(validatorsdir(root), group, testmod, solution.user)
  if solution.version ~= nil then
    return p.join(x, solution.version .. ".ak")
  end
  return x .. ".ak"
end

local function getaikenfiles(path)
  assert (p.exists(path)) -- exists
  local files = {}
  for child in lfs.dir(path) do
    local cpath = p.join(path, child)
    local attr = lfs.attributes (cpath)
    assert (type(attr) == "table") -- exists
    if attr.mode == "directory" then
      if child ~= "." and child ~= ".." then
        files[child] = getaikenfiles(cpath)
      end
    elseif child:match".ak$" and child ~= "_.ak" then
      files[child:sub(0, child:len() - 3)] = child
    end
  end
  return files
end

-- user/challenge.ak 
-- user/challenge/version.ak
-- { user1 : { sol1.ak, sol2 : { v0 : v0.ak , v1: v1.ak } } }

local function stack(t, key, value)
  if t[key] ~= nil then
    t[key][#t[key] + 1] = value
  else
    t[key] = {value,}
  end
  return t
end

local function mksolution(user, group, version)
  return {
    user = user,
    group = group,
    version = version,
  }
end

local function getsolutions(path)
  local allsolutions = getaikenfiles(solutionsdir(path))
  local paths = {}
  for user, groups in pairs(allsolutions) do
    for group, groupT in pairs(groups) do
      if type(groupT) == "string" then
        stack(paths, group, mksolution(user, group, nil))
      elseif type(groupT) == "table" then
        for version, _ in pairs(groupT) do
          stack(paths, group, mksolution(user, group, version))
        end
      end
    end
  end
  print(pretty.dump(paths))
  return paths
end

local function gettests(path)
    return getaikenfiles(testsdir(path))
end

local function readtest(root, group, testmod)
  return p.readall(testpath(root, group, testmod))
end

local function writetest(root, group, testmod, solution, test)
  p.mkdirs(validatorsdir(root), group, testmod)
  if solution.version ~= nil then
    p.mkdirs(validatorsdir(root), group, testmod, solution.user)
  end
  return p.writefile(outpath(root, group, testmod, solution), test)
end

return {
  getsolutions = getsolutions,
  gettests = gettests,
  readtest = readtest,
  writetest = writetest,
  validatorsdir = validatorsdir,
  solutionpath = solutionpath ,
}
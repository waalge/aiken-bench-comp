local o = require "org"
local p = require "paths"

local function clean(root)
  os.execute("rm --recursive " ..
    p.join(o.validatorsdir(root), "*")
  )
end

return {
  clean = clean,
}

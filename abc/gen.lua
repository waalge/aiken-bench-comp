local lustache = require "lustache"
local o = require "org"

local gen = {}

function gen.gen(args)
  local solutions = o.getsolutions(args.root)
  local tests = o.gettests(args.root)
  for user,challenges in pairs(solutions) do
    for _, challenge in pairs(challenges) do
      if tests[challenge] == nil then
        print("Bad challenge : ", user, challenge)
      else
        for _, testname in pairs(tests[challenge]) do
          o.writetest(args.root, challenge, testname, user, lustache:render(
            o.readtest(args.root, challenge, testname), {
             user = user,
            })
          )
        end
      end
    end
  end
end

return gen

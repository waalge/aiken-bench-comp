local lustache = require "lustache"
local o = require "org"
local pretty = require "pretty"

local gen = {}

function gen.gen(args)
  local allsolutions = o.getsolutions(args.root)
  local alltests = o.gettests(args.root)
  for group, solutions in pairs(allsolutions) do
    if alltests[group] == nil then
      print(group)
      print(pretty.dump(solutions))
      error("Bad testgroup: " .. group)
    end
    for _, solution in pairs(solutions) do
      for testname, _ in pairs(alltests[group]) do
        o.writetest(args.root, group, testname, solution, lustache:render(
          o.readtest(args.root, group, testname), {
           path = o.solutionpath(solution),
          })
        )
      end
    end
  end
end

return gen

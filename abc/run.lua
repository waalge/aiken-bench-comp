local p = require "paths"
local json = require ("dkjson")

local function sample()
  return [[
	    Compiling aiken-lang/stdlib main (./bench/build/packages/aiken-lang-stdlib)
    Compiling waalge/bench 0.0.0 (./bench)
      Testing ...

    ┍━ fib/basic/waalge ━━━━━━━━━━━━━━━━━━━━━━━━━
    │ PASS [mem:     5305, cpu:     1984485] fib0
    │ PASS [mem:    34557, cpu:    15399449] fib5
    │ PASS [mem:   225297, cpu:   102775879] fib40
    │ PASS [mem:  5615815, cpu:  2573872705] fib1000
    │ PASS [mem: 56638159, cpu: 26135232291] fib10000
    ┕━━━━━━━━━━━━━━━━━━ 5 tests | 5 passed | 0 failed

    ┍━ fib/basic/waalge2 ━━━━━━━━━━━━━━━━━━━━━━━━━
    │ FAIL [mem:     5305, cpu:     1984485] fib0
    │ PASS [mem:    34557, cpu:    15399449] fib5
    │ PASS [mem:   225297, cpu:   102775879] fib40
    │ PASS [mem:  5615815, cpu:  2573872705] fib1000
    │ PASS [mem: 56638159, cpu: 26135232291] fib10000
    ┕━━━━━━━━━━━━━━━━━━ 5 tests | 5 passed | 0 failed


Summary
    0 errors, 0 warnings    
  ]]
end

local function result(group, testmod, user, version, passfail, mem, cpu, testname)
  return {
    group=group,
    testmod=testmod,
    user=user,
    version=version,
    ispass = passfail == "PASS",
    mem=tonumber(mem),
    cpu=tonumber(cpu),
    testname=testname
  }
end

local function parseblock(res)
  local group, testmod, user, version = res:match("(%w+)/(%w+)/(%w+)/(%w+) ")
  if version == nil then
    group, testmod, user = res:match("(%w+)/(%w+)/(%w+) ")
  end
  local results = {}
  local ii = 1
  for passfail, mem, cpu, testname in res:gmatch("│ (%w+) %[mem: +(%w+), cpu: +(%w+)] (%w+)\n") do
    results[ii] = result(group, testmod, user, version, passfail, mem, cpu, testname)
    ii = ii + 1
  end
  return results
end

local function concat(t1,t2)
  for i=1,#t2 do
    t1[#t1+1] = t2[i]
  end
  return t1
end


local function parseall(res)
  local results = {}
  local ii = 1
  for block in res:gmatch("┍━ (.-)┕━") do
    concat(results, parseblock(block))
  end
  return results
end

local function writeresult(jsonstr)
  p.writefile("results.json", jsonstr)
end

local function tojson(t)
  return json.encode (t, { indent = true })
end

local function run(root)
  local f = io.popen("aiken check " .. root .. " 2>&1")
  if f == nil then
    error("Something went wrong")
  else
    local raw = f:read("*a")
    local t = parseall(raw)
    local j = tojson(t)
    writeresult(j)
    print(j)
  end
end

return {
  run = run,
}

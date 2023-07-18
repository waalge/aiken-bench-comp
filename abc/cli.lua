local argparse = require "argparse"

local genh = require "gen"
local runh = require "run"
local cleanh = require "clean"
local pretty = require "pretty"

local parser = argparse("abc", "Aiken Bench Cli")

local gen = parser:command("gen", "Generate tests")
gen:argument("root", "Aiken root"):default("./")

local clean = parser:command("clean", "Clean all generated files")
clean:argument("root", "Aiken root"):default("./")

local run = parser:command("run", "Run all tests")
run:argument("root", "Aiken root"):default("./")

local function cli()
  local args = parser:parse()
  if args["gen"] ~= nil then
    return genh.gen(args)
  end
  if args["run"] ~= nil then
    return runh.run(args.root)
  end
  if args["clean"] ~= nil then
    return cleanh.clean(args.root)
  end
  print(pretty.dump(args))
end

return cli
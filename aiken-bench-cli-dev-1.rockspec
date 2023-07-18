package = "aiken-bench-cli"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "lua >= 5.4", 
   "argparse",
   "luafilesystem",
   "lustache",
   "dkjson",
}
build = {
   type = "builtin",
   modules = {
      cli = "abc/cli.lua",
      gen = "abc/gen.lua",
      run = "abc/run.lua",
      clean = "abc/clean.lua",
      org = "abc/org.lua",
      paths = "abc/paths.lua",
      pretty = "abc/pretty.lua",
   },
   install = {
      bin = {
         "abc/abc"
      }
   }
}

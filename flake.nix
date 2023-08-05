{
  description = "Kompact project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks-nix.url = "github:hercules-ci/pre-commit-hooks.nix/flakeModule";
    pre-commit-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
    aiken.url = "github:aiken-lang/aiken";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      project-root = builtins.toString ./.; 
    in 
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          inputs.pre-commit-hooks-nix.flakeModule
          inputs.devshell.flakeModule
        ];
        systems = [ "x86_64-linux" "aarch64-darwin" ];
        perSystem = { config, self', inputs', pkgs, ... }: {
          pre-commit.settings.hooks = {
            nixpkgs-fmt.enable = true;
            markdownlint.enable = true;
          };
          devshells.default = {
            name = "aiken-bench";
            env = [
              {
                name = "PATH";
                prefix = "lua_modules/bin";
              }
            ];
            commands = [
              {
                name = "abc-install";
                category = "aiken-bench-cli";
                command = ''
                  luarocks install --tree=lua_modules --only-deps *rockspec
                '';
                help = "Install deps of abc tool";
              }
              {
                name = "abc-make";
                category = "aiken-bench-cli";
                command = ''
                  luarocks make --tree=lua_modules
                '';
                help = "Make abc";
              }
              {
                name = "serve-results";
                category = "site";
                command = ''
                  caddy file-server --root ./site/ --listen :5555
                '';
                help = "Serve results as interactable table";
              }
            ];
            devshell.startup.${"precommit"}.text = ''
              ${config.pre-commit.installationScript}
            '';
            packages = [
              inputs'.aiken.packages.aiken
              pkgs.lua54Packages.lua
              pkgs.lua54Packages.luarocks
              pkgs.lua54Packages.luafilesystem
              pkgs.lua54Packages.argparse
              pkgs.caddy
              pkgs.nodePackages_latest.typescript-language-server
            ];
          };
        };
        flake = { };
      };
}

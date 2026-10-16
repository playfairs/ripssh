{
  description = "RipSSH development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nox = {
      url = "github:playfairs/nox/dev";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nox, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = function: nixpkgs.lib.genAttrs systems (system: function system);
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          ldc =
            if pkgs.stdenv.hostPlatform.isDarwin then
              let
                ldcConfig = pkgs.runCommand "ripssh-ldc-config" { } ''
                  mkdir -p "$out"
                  cp ${pkgs.ldc}/etc/ldc2.conf/*.conf "$out/"
                  rm "$out/70-compiler-rt.conf"
                '';
              in
              pkgs.writeShellScriptBin "ldc2" ''
                exec ${pkgs.ldc}/bin/ldc2 \
                  --conf=${ldcConfig} \
                  --gcc=${pkgs.llvmPackages.clang-unwrapped}/bin/clang \
                  "$@"
              ''
            else
              pkgs.ldc;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.clang
              ldc
              nox.packages.${system}.nox
            ];
          };
        }
      );
    };
}

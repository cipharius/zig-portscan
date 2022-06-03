{
  description = "zig-portscan dev environment";

  inputs = {
    zig-source = { url = "github:ziglang/zig/83beed0"; flake = false; };
    zig-args = { url = "github:MasterQ32/zig-args"; flake = false; };
  };

  outputs = {
    self,
    nixpkgs,
    zig-source,
    zig-args
  }:
  let
    default_system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${default_system};
    zig_0_10_0 = pkgs.zig.overrideAttrs (prev: rec {
      version = "0.10.0";
      src = zig-source.outPath;

      nativeBuildInputs = with pkgs; [
        cmake
        llvmPackages_13.llvm.dev
      ];

      buildInputs = with pkgs; [
        libxml2
        zlib
        llvmPackages_13.libclang
        lld_13
        llvm_13
      ];
    });
  in {
    devShell.${default_system} = pkgs.mkShell {
      nativeBuildInputs = [
        zig_0_10_0
      ];

      shellHook = ''
        alias nix-install-dependencies="nix build -o external .#dependencies"
      '';
    };

    packages.${default_system}.dependencies = pkgs.stdenv.mkDerivation {
      name = "zig-portscan-dependencies";

      srcs = [
        zig-args.outPath
      ];
      sourceRoot = ".";

      dontBuild = true;

      installPhase = ''
        mkdir "$out"
        ln -s "${zig-args.outPath}" "$out"/zig-args
      '';
    };
  };
}

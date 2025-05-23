{ inputs, ... }:
{
  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    {
      # Add rust-overlay to `pkgs`
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.rust-overlay.overlays.default ];
      };

      legacyPackages.rust = rec {
        extensions = [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
          "rust-analyzer"
        ];

        toolchains.stable = pkgs.rust-bin.stable.latest.minimal.override { inherit extensions; };
        toolchains.nightly = pkgs.rust-bin.selectLatestNightlyWith (
          toolchain: toolchain.minimal.override { inherit extensions; }
        );
      };
    };

  imports = [ ../crates ];
}

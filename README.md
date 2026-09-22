# lmms-appimage

LMMS music production suite packaged from the **official upstream AppImage**
instead of nixpkgs, so every bundled plugin works: ZynAddSubFX, VeSTige/VST,
SoundFont2, GIG player, Carla/LV2 and all native instruments and effects.

- Upstream: https://lmms.io / https://github.com/LMMS/lmms
- AppImage: `lmms-1.3.0-alpha.2-linux-x86_64.AppImage`
- Binary: `lmms` (with `.desktop` launcher + icons)
- Platform: `x86_64-linux`

> Note: `1.3.0-alpha.x` is a pre-release. Project files saved with it cannot
> be reopened in LMMS 1.2.x (one-way upgrade, per upstream).

## Try it

```bash
nix run github:Matko802/lmms-appimage-nix
```

## Use in your NixOS flake

```nix
# flake.nix inputs
lmms-appimage = {
  url = "github:Matko802/lmms-appimage-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

```nix
# overlay
nixpkgs.overlays = [ inputs.lmms-appimage.overlays.default ];
```

```nix
# replace nixpkgs lmms with the AppImage build
users.users."you".packages = with pkgs; [
  lmms-appimage
];
```

## Update to a newer AppImage

1. Find the asset URL at https://github.com/LMMS/lmms/releases
2. Prefetch it:
   ```bash
   nix-prefetch-url --type sha256 <AppImage-URL>
   ```
3. Convert the base32 hash to SRI:
   ```bash
   nix hash convert --hash-algo sha256 --to sri <base32-hash>
   ```
4. Bump `version` / `hash` in `package.nix`.

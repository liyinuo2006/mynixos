# AGENTS.md — mynixos

Personal NixOS flake for a single machine (hostname: `vostro-3420`).

## Quick start

```bash
# Build & switch (requires sudo)
sudo nixos-rebuild switch --flake .#mynixos

# Build only (dry-run)
nixos-rebuild build --flake .#mynixos

# Format all Nix files (uses nixfmt, no project-local config)
nix fmt

# Update inputs
nix flake update
nix flake lock --update-input <name>
```

## Architecture

- **Host**: `hosts/vostro-3420/` — single machine, imports all NixOS modules + home-manager
- **NixOS modules** (`modules/nixos/`): `core/` (essential), `desktop/` (niri compositor),
  `programs/` (clash-verge, packages, nautilus), `dm/` (LY display manager)
- **Home-manager modules** (`modules/hm/`): `desktop/` (niri config, noctalia theme),
  `i18n/` (fcitx5-rime-ice Chinese input), `programs/` (shell/fish, git, zed-editor,
  packages with WeChat/WPS wrappers), `ai-agent/` (opencode config)

All modules are imported through chain of `default.nix` aggregators —
never bypass the module system.

## Conventions

- **Formatting**: `nixfmt` only — no other Nix formatter. Run `nix fmt` before
  committing if you touch `.nix` files.
- **LSP**: `nixd` only — `nil` is explicitly disabled in `zed-editor.nix`.
  Disable `sema-extra-with` diagnostic in nixd if false positives appear.
- **Shell**: fish with starship prompt. Aliases in `modules/hm/programs/shell.nix`.
- **Comments**: in Chinese throughout.
- **No CI, no tests, no pre-commit hooks** — manual `nixos-rebuild switch` is the
  only deployment method.
- **Btrfs** with subvolumes (root, home, nix). `hardware-configuration.nix` is
  auto-generated — edit `configuration.nix` instead (not present in repo; managed
  on-machine).

## Inputs

| Name | Source |
|------|--------|
| `nixpkgs` | `NixOS/nixpkgs/nixos-unstable` |
| `home-manager` | `nix-community/home-manager` (follows nixpkgs) |
| `noctalia` | `noctalia-dev/noctalia/cachix` (theming) |
| `zen-browser` | `0xc000022070/zen-browser-flake/beta` (browser; follows nixpkgs + home-manager) |

Substituters configured for Tsinghua mirror, nix-community cachix, and
noctalia cachix.

## Environment quirks

- `opencode` is installed via home-manager (`modules/hm/ai-agent/opencode.nix`).
  The repo itself is opened with the local opencode, so **never change opencode's
  own config in a way that would break the current session**.
- Fish alias `oc` enables opencode with `OPENCODE_ENABLE_EXA=1
  OPENCODE_EXPERIMENTAL=true OPENCODE_EXPERIMENTAL_PARALLEL=true`.
- WeChat and WPS Office are wrapped with fcitx/Chinese-locale env vars
  (`modules/hm/programs/packages.nix`).
- `niri` config uses out-of-store symlinks (`mkOutOfStoreSymlink`) pointing to
  files under `modules/hm/desktop/niri-config/`.
- `system.stateVersion = "26.05"` — do not bump without understanding
  implications.

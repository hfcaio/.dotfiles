# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal Nix flake managing two home-manager profiles plus one NixOS system:

- `nixOS` — full NixOS system config (desktop machine)
- `caio@nixOS` — home-manager profile wired into that system
- `caio-freitas@ubuntu` — standalone home-manager profile for CLI tooling on Ubuntu 24.04 (no NixOS, no desktop modules)

The repo path is **hard-coded as `/home/caio/git_projects/.dotfiles`** in `home/features/cli/zsh.nix` (`scripts_dir`). Don't move the repo without updating that reference.

## Commands

| Command | What it does |
|---|---|
| `nrs` | `sudo nixos-rebuild switch --flake .` — NixOS only |
| `nfu` | `nix flake update && nrs` — update all inputs + rebuild |
| `nix flake update <input>` then `nrs` | update a single input |
| `home-manager switch --flake .#caio@nixOS` | home-manager only on NixOS |
| `home-manager switch --flake .#caio-freitas@ubuntu` | apply on Ubuntu |
| `nix run home-manager/release-26.05 -- switch --flake .#caio-freitas@ubuntu` | first-time apply on Ubuntu before home-manager is in PATH |

No tests, lint, or CI — changes are validated by `nixos-rebuild switch` succeeding.

## Architecture

### Entry points
`flake.nix` exposes three outputs that matter:
- `nixosConfigurations.nixOS` → `hosts/nixOS/` (imports `hosts/common/` for the user)
- `homeConfigurations."caio@nixOS"` → `home/caio/nixOS.nix`
- `homeConfigurations."caio-freitas@ubuntu"` → `home/caio-freitas/ubuntu.nix`

`hosts/common/users/caio.nix` wires home-manager into the NixOS system by importing `home/caio/${networking.hostName}.nix` dynamically — so the hostname (`nixOS`) must match the filename.

### Feature-flag pattern
Every file under `home/features/{cli,desktop}/` is a module that:
1. Declares an `options.features.<category>.<name>.enable = mkEnableOption ...`
2. Guards its config with `mkIf cfg.enable`

The `default.nix` in each features directory **auto-imports every `.nix` file in the folder** (via `builtins.readDir`). Adding a new feature = drop a file following the pattern — no need to touch any default.nix. Enabling it = set `features.<category>.<name>.enable = true;` in the per-user profile (`home/caio/nixOS.nix` or `home/caio-freitas/ubuntu.nix`).

The feature file itself only installs tools and writes config; which features are on lives in the profile.

### Custom packages & overlays
`pkgs/` holds callPackage-style derivations (matlab, matlab-shell, webots-fhs, unitree_sdk2, claude-desktop). They're exposed through `overlays/default.nix` → `additions` and reachable as plain `pkgs.<name>` anywhere in the config.

### Scripts (git submodule)
`scripts/` is a separate repo (`git@github.com:hfcaio/scripts.git`). After cloning, run `git submodule update --init`. The `blt` alias and anything else there resolves via the hard-coded `scripts_dir` in `zsh.nix`.

## Non-obvious things that will bite you

- **Hyprland is pinned to commit `e0d9283...` (0.44, 2026-07-14)** in `flake.nix`. Hyprland 0.56+ switched to Lua config and breaks hyprlang + the auto-generated `hyprland.lua`. Unpin only when migrating config.
- **Ubuntu + GUI apps need nixGL wrapping** for OpenGL (see recent `ghostty` commits — the `.desktop` Exec line was changed to call the nixGL-wrapped binary). Don't naively add new GUI apps to the Ubuntu profile without this.
- **fcitx5 is forced to Brazilian layout** in `home/caio/home.nix` because XIM clients (Java/AWT — notably the MATLAB IDE) receive keys already translated and would otherwise get a US layout. Keep the explicit `GroupOrder`/`Groups/0` block.
- **`home.stateVersion = "26.05"`** — do not change without reading home-manager release notes.
- **`users.users.caio.initialPassword = "1234"`** applies only on first activation; `passwd` takes precedence after that and survives rebuilds.
- **`.gitignore` excludes `*.zip`, `*.tar.gz`, `*.deb`** etc. — don't commit installer blobs; use proper derivations in `pkgs/`.
- **Writing LSP configs for ROS-in-Docker projects**: README.md documents the `.nvim.lua` pattern that calls `docker exec -i <container> clangd`. Neovim already has `vim.opt.exrc = true`.

## When adding a new feature

1. Create `home/features/{cli,desktop}/<name>.nix` following the `mkEnableOption` + `mkIf cfg.enable` pattern (copy any existing file as template).
2. Enable it in the relevant profile (`home/caio/nixOS.nix` for desktop machine, `home/caio-freitas/ubuntu.nix` for CLI-only Ubuntu).
3. **`git add` the new file** before `nrs` (see below).
4. Rebuild with `nrs` (NixOS) or `home-manager switch --flake .#<profile>` (Ubuntu).

Don't touch `home/features/*/default.nix` — the auto-import handles it.

### Where packages go — strict rules

- **Never add packages directly to `home.packages` in `home/caio/home.nix` or `home/caio-freitas/ubuntu.nix`.** Each app gets its own feature file under `home/features/{cli,desktop}/`. The per-user profile only toggles features on/off. If a package feels too small to deserve a file (e.g. `vlc`, `brave`), it still gets its own feature file — that's the point of the pattern.
- **System-level tools (udev/usb/kernel-adjacent, e.g. `usbutils`, `pciutils`) go in `environment.systemPackages` in `hosts/nixOS/configuration.nix`**, not in a home-manager feature. They need to be available to all users and to root (e.g. `lsusb` under `sudo`).
- `home/caio/home.nix` is for home-manager *settings* (stylix, fcitx5, session vars, dotfile symlinks) — not for installing packages.

### Recurring build-time pitfalls

- **New files must be `git add`ed before `nrs`.** Nix flakes evaluate from the git tree and silently ignore untracked files. Symptom: `error: The option 'features.desktop.<new>' does not exist` even though the file is on disk. Fix: `git add home/features/desktop/<new>.nix` and rebuild. The `warning: Git tree ... is dirty` only means uncommitted — staged is enough; you don't need to commit.
- **Stylix conflicts with explicit theme/font settings.** `stylix.enable = true` in `home.nix` claims options like `programs.vscode.profiles.default.userSettings."workbench.colorTheme"`, `editor.fontFamily`, etc. Setting the same key in a feature file (e.g. `code.nix`) produces `error: ... has conflicting definition values`. Default: delete the explicit setting and let stylix drive the theme. Only use `lib.mkForce "value"` when you deliberately want to override stylix for that one key.
- **home-manager refuses to clobber pre-existing dotfiles.** First time a feature manages a file that already exists on disk (e.g. `~/.config/Code/User/settings.json` from a prior non-nix install), activation fails with `Existing file '...' would be clobbered`. Fix: `mv <path>{,.bak}` and rebuild. The repo intentionally does *not* set `home-manager.backupFileExtension`, so collisions are surfaced instead of silently backed up.

## graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

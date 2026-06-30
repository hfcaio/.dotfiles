# dotfiles

NixOS configuration using flakes, home-manager, disko, stylix and hyprland.

## Structure

```
.
├── flake.nix                  # Entrypoint — inputs and outputs
├── hosts/
│   ├── common/                # Shared config across all hosts
│   │   └── users/caio.nix     # User definition + home-manager binding
│   └── nixOS/                 # Machine-specific configuration
│       ├── configuration.nix  # Services, hardware, virtualisation
│       ├── disko-config.nix   # Partition layout
│       └── hardware-configuration.nix
├── home/
│   ├── common/                # nixpkgs overlays and base nix settings
│   ├── caio/
│   │   ├── nixOS.nix          # User profile for the nixOS machine
│   │   ├── ubuntu.nix         # User profile for Ubuntu (CLI only)
│   │   ├── home.nix           # Base packages, terminal, variables
│   │   └── ssh.nix            # SSH keys
│   └── features/
│       ├── cli/               # Terminal tools (opt-in per feature)
│       └── desktop/           # GUI applications (opt-in per feature)
```

## Available features

Each feature has its own `.nix` file and is enabled in the machine profile.

### CLI — `home/features/cli/`

| Feature | Packages |
|---|---|
| `zsh` | zsh + plugins |
| `starship` | starship prompt |
| `nvim` | neovim + LSP (clangd, pyright, nil, lua-ls, tinymist) |
| `fzf` | fzf |
| `direnv` | direnv |
| `python` | python3 + pip |
| `lsp` | LSP servers for C/C++, Python, Nix, Lua, Typst |
| `fetch` | neofetch |

Base packages always present: `btop`, `tldr`, `zip`, `unzip`, `wget`, `nixfmt`.

### Desktop — `home/features/desktop/`

| Feature | Packages |
|---|---|
| `hyprland` | Hyprland + waybar + rofi + swaylock + etc. |
| `rofi` | rofi-wayland |
| `rofi-powermenu` | power menu with rofi |
| `nautilus` | GNOME file manager |
| `thunar` | XFCE file manager |
| `discord` | Discord |
| `obs` | OBS Studio |
| `vagrant` | Vagrant |
| `claude` | Claude Code CLI |
| `arduino` | arduino-ide + arduino-cli |
| `typst` | typst + tinymist |
| `latex` | texlive |
| `octave` | GNU Octave |
| `blender` | Blender |
| `gcs` | Google Cloud SDK |
| `ipscan` | Angry IP Scanner |
| `rpi_imager` | Raspberry Pi Imager |

## Aliases

| Alias | Command | Description |
|---|---|---|
| `nrs` | `sudo nixos-rebuild switch --flake .` | Apply config changes |
| `nfu` | `nix flake update && sudo nixos-rebuild switch --flake .` | Update all inputs and rebuild |
| `blt` | `scripts/blt` | Bluetooth device selector |
| `matlab` | `docker start matlab && docker exec ...` | Start MATLAB in Docker |

## Fresh install with disko

### 1. Boot from NixOS ISO

Download at https://nixos.org/download and boot the machine from the live ISO.

### 2. Connect to the internet

```bash
# Wi-Fi
nmtui

# Ethernet works automatically
```

### 3. Clone the dotfiles

```bash
nix-shell -p git
git clone https://github.com/<user>/dotfiles /tmp/dotfiles
cd /tmp/dotfiles
```

### 4. Adjust the disk in `disko-config.nix`

Check the correct disk name:

```bash
lsblk
```

Edit if needed:
```nix
device = "/dev/nvme0n1";  # <- adjust to the correct disk
```

Current layout:
- 512MB EFI partition at `/boot`
- ext4 root partition with remaining space at `/`

### 5. Partition and format with disko

```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko /tmp/dotfiles/hosts/nixOS/disko-config.nix
```

### 6. Generate hardware-configuration

```bash
sudo nixos-generate-config --no-filesystems --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/dotfiles/hosts/nixOS/hardware-configuration.nix
```

### 7. Install the system

```bash
sudo nixos-install --flake /tmp/dotfiles#nixOS
```

### 8. Reboot

```bash
reboot
```

### 9. Set your password

After logging in with the initial password, change it permanently:

```bash
passwd
```

This change is permanent — `nixos-rebuild switch` will never overwrite a password set with `passwd`.

---

## User password

The config uses `initialPassword` in `hosts/common/users/caio.nix`, which sets a plain-text default password applied **only on the first activation**. After that, `passwd` takes precedence.

```nix
users.users.caio = {
  initialPassword = "1234";
  ...
};
```

To change the password at any time:

```bash
passwd
```

---

## Setting up on Ubuntu 24.04

The `caio@ubuntu` home-manager profile installs the full CLI setup (zsh, starship, neovim + LSPs, fzf, direnv, python) via Nix, without any desktop or NixOS-specific modules.

### 1. Install Nix

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

Close and reopen the terminal after the installer finishes.

### 2. Clone the dotfiles

```bash
git clone https://github.com/<user>/dotfiles ~/git_projects/.dotfiles
cd ~/git_projects/.dotfiles
```

> The path `~/git_projects/.dotfiles` must match, since `zsh.nix` references scripts from that location.

### 3. Apply the Ubuntu profile

```bash
nix run home-manager/release-26.05 -- switch --flake .#caio@ubuntu
```

This builds and links all configs into `~/.config` and `~/.local`.

### 4. Set zsh as the default shell

```bash
chsh -s $(which zsh)
```

Log out and back in for the change to take effect.

### Updating

```bash
cd ~/git_projects/.dotfiles
home-manager switch --flake .#caio@ubuntu
```

> The `nrs` and `nfu` aliases defined in `zsh.nix` are NixOS-only and have no effect on Ubuntu — they can be safely ignored.

---

## Applying changes

### Full system rebuild

```bash
sudo nixos-rebuild switch --flake .#nixOS
# or use the alias:
nrs
```

### Update all flake inputs and rebuild

```bash
nfu
```

### Update a single input

```bash
nix flake update nixpkgs
nrs
```

### Home-manager only

```bash
home-manager switch --flake .#caio@nixOS
```

---

## LSP in ROS projects (Docker)

Since ROS runs inside Docker, the LSP on the host can't find the headers. To fix this per project, create a `.nvim.lua` at the project root:

```lua
vim.lsp.config('clangd', {
  cmd = { "docker", "exec", "-i", "container_name", "clangd" }
})
```

Neovim loads this file automatically when opening the project (`vim.opt.exrc = true` is already set in the config). On first load it will ask for confirmation.

For VSCode, use the **Dev Containers** extension with a `.devcontainer/devcontainer.json` at the project root.

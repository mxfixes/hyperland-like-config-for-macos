# dotfiles

A "Linux-flavored" macOS setup: Kitty terminal, yabai (tiling WM), skhd (keybinds),
SketchyBar (status bar), and a `pacman`-syntax wrapper around Homebrew.

Not a real Arch/Hyprland install — this reskins macOS to feel like one. `fastfetch`
config is intentionally excluded from this repo (kept local/cosmetic only).

## What's included

| Tool      | Role                          | Config          |
|-----------|-------------------------------|------------------|
| Homebrew  | Package manager backend       | -                |
| `pacman()`| pacman-syntax → brew wrapper  | `zsh/.zshrc`     |
| yabai     | Tiling window manager         | `yabai/.yabairc` |
| skhd      | Hotkey daemon (keybinds)      | `skhd/.skhdrc`   |
| Kitty     | Terminal emulator             | `kitty/kitty.conf` |
| SketchyBar| Status bar (Waybar-style)     | cloned separately, see below |

## Requirements

- macOS on Apple Silicon (M1/M2/M3)
- [Homebrew](https://brew.sh) installed

## Install

run the install.sh file it will install or download and run the dmg

The script will:
1. Install Homebrew if missing
2. Tap `koekeishiya/formulae` (yabai, skhd) and `FelixKratz/formulae` (sketchybar)
3. Install yabai, skhd, sketchybar, kitty (cask)
4. Symlink configs into place (`~/.zshrc`, `~/.yabairc`, `~/.skhdrc`, `~/.config/kitty/kitty.conf`)
5. Clone a SketchyBar starter config into `~/.config/sketchybar`
6. Start yabai and skhd services

## Keybinds (skhd)

| Keybind              | Action                                   |
|-----------------------|-------------------------------------------|
| `Alt+H/J/K/L`          | Focus window (west/south/north/east)      |
| `Alt+1` / `Alt+2`      | Move focused window to space 1 / 2        |
| `Alt+B`                | Toggle SketchyBar visibility              |
| `Alt+F`                | Start yabai                               |
| `Shift+Alt+F`          | Stop yabai                                |
| `Right Shift + /`      | Reload skhd + yabai + sketchybar configs  |


## pacman wrapper

Once sourced, `pacman` maps to brew:

```bash
pacman -S <package>    # brew install
pacman -R <package>    # brew uninstall
pacman -Ss <package>   # brew search
pacman -Si <package>   # brew info
pacman -Syu            # brew update && brew upgrade
pacman -Qe             # brew list
pacman -Sc             # brew cleanup
```

Anything unmapped falls through to `brew "$@"` directly.

## Uninstall / revert

```bash
./install.sh --uninstall
```

Removes the symlinks (leaves Homebrew and installed packages alone).

## Why

Built while messing around trying to make a shared family Mac feel like an
Arch + Hyprland setup, without touching the actual OS or risking a dual-boot
on Apple Silicon. Real Arch + Hyprland lives on a separate PC — this is just
the "reskin, don't repartition" version.

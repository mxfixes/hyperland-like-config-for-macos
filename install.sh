#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up existing $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

uninstall() {
  echo "Removing symlinks..."
  for f in ~/.zshrc ~/.yabairc ~/.skhdrc ~/.config/kitty/kitty.conf; do
    if [ -L "$f" ]; then
      rm "$f"
      echo "Removed $f"
      if [ -e "$f.bak" ]; then
        mv "$f.bak" "$f"
        echo "Restored $f from backup"
      fi
    fi
  done
  echo "Done. Homebrew and installed packages were left untouched."
  exit 0
}

if [ "$1" = "--uninstall" ]; then
  uninstall
fi

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Taps
brew tap koekeishiya/formulae
brew tap FelixKratz/formulae

# 3. Packages
brew install yabai skhd sketchybar
brew install --cask kitty

# 4. Symlink configs
mkdir -p ~/.config/kitty
link "$DOTFILES_DIR/zsh/zshrc[remove_this_placeholder]" ~/.zshrc
link "$DOTFILES_DIR/yabai/yabairc[remove_this_placeholder]" ~/.yabairc
link "$DOTFILES_DIR/skhd/skhdrc[remove_this_placeholder]" ~/.skhdrc
link "$DOTFILES_DIR/kitty/kitty.conf" ~/.config/kitty/kitty.conf
chmod +x ~/.yabairc

# 5. SketchyBar starter config (cloned fresh, not vendored in this repo)
if [ ! -d ~/.config/sketchybar ]; then
  echo "Fetching SketchyBar starter config..."
  tmp=$(mktemp -d)
  git clone --depth 1 https://github.com/FelixKratz/dotfiles "$tmp"
  mkdir -p ~/.config/sketchybar
  cp -r "$tmp/.config/sketchybar/"* ~/.config/sketchybar/
  rm -rf "$tmp"
  chmod +x ~/.config/sketchybar/sketchybarrc
fi

# 6. Start services
yabai --start-service
skhd --start-service
brew services start sketchybar || sketchybar &

echo ""
echo "Done. A few manual steps still required:"
echo "  1. System Settings -> Privacy & Security -> Accessibility -> enable yabai and skhd"
echo "  2. System Settings -> Keyboard -> Keyboard Shortcuts -> disable 'Log Out' (conflicts with Cmd+Shift+Q)"
echo "  3. Open a new terminal, or run: source ~/.zshrc"

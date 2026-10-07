#!/data/data/com.termux/files/usr/bin/bash
set -e
BASE="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

printf '\033[1;36mTermux Zamux Pack installer\033[0m\n'
printf '\033[1;33mIf Termux asks you to choose a mirror, select Main repository and a nearby mirror.\033[0m\n'

# Repair missing mirror selection and mismatched Termux libraries.
if ! apt update; then
  if command -v termux-change-repo >/dev/null 2>&1; then
    termux-change-repo
  else
    printf '\033[1;31mRun termux-change-repo first, then run this installer again.\033[0m\n'
    exit 1
  fi
fi

apt update
apt full-upgrade -y
apt install --reinstall curl git openssl libcurl -y 2>/dev/null || apt install curl git openssl -y
pkg install zsh -y
pkg install bat -y 2>/dev/null || true

mkdir -p "$HOME/.termux" "$HOME/.local/bin"
cp "$BASE/.termux/colors.properties" "$HOME/.termux/colors.properties"
cp "$BASE/.local/bin/pfetch" "$HOME/.local/bin/pfetch"
chmod +x "$HOME/.local/bin/pfetch"
: > "$HOME/.hushlogin"

# Install Oh-My-Zsh without using curl's remote installer.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
cp "$BASE/.zshrc" "$HOME/.zshrc"
# Make Zsh the default shell so .zshrc loads after reopening Termux.
if command -v chsh >/dev/null 2>&1; then
  chsh -s zsh 2>/dev/null || true
fi
command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings || true
printf '\033[1;32mInstalled successfully.\033[0m\n'
printf 'Run: exec zsh\n'

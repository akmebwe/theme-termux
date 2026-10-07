# Termux Zamux Pack
export PATH="$HOME/.local/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gnzh"
plugins=(git)

if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Prompt
PROMPT='%F{cyan}┌─[ %F{green}%n@%m%F{cyan} ]─[ %F{magenta}%~%F{cyan} ]\n%F{yellow}└─➜%f '

# Show pfetch once when a new Zsh session starts
if [ -x "$HOME/.local/bin/pfetch" ]; then
  "$HOME/.local/bin/pfetch"
fi

alias ll='ls -lah'
alias c='clear'

# English warning before dangerous Android/system commands
android_danger_warning() {
  local cmd="$1"
  case "$cmd" in
    *"adb shell pm uninstall -k --user 0"*|\
    *"adb shell rm -rf"*|\
    *"fastboot flash"*|\
    *"rm -rf"*|\
    *"mkfs"*|\
    *"dd if="*|\
    *"git reset --hard"*|\
    *"chmod -R 777"*|\
    su|su\ *|/su|/su\ *)
      print -P "\n%F{red}%B╔══════════════════════════════════╗%b%f"
      print -P "%F{red}%B║      DANGEROUS COMMAND WARNING! ║%b%f"
      print -P "%F{red}%B╚══════════════════════════════════╝%b%f"
      print -P "%F{yellow}Command about to run:%f %F{white}${cmd}%f"
      print -P "%F{red}%BThis command may remove apps, delete data, or damage your device.%b%f"
      print -P "%F{yellow}Review the command carefully before continuing.%f\n"
      printf '\a'
      ;;
  esac
}

typeset -ga preexec_functions
preexec_functions=(${preexec_functions:#android_danger_warning} android_danger_warning)

## Install   theme Termux

```bash
pkg update -y
pkg install git -y

cd ~
git clone https://github.com/akmebwe/theme-termux.git 
cd ~/theme-termux

chmod +x install.sh
bash install.sh
exec zsh
```
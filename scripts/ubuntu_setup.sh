#!/bin/bash

echo "[-] Running sudo apt update + upgrade [-]"
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
echo "[-] Downloading Useful Applications [-]"

echo "    VsCode.... "
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

echo "    Slack..."
wget -O slack.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-4.17.0-amd64.deb
sudo apt install ./slack.deb
#rm slack.deb

echo "    discord...."
wget -O discord.deb https://discord.com/api/download?platform=linux&format=deb
sudo apt install ./discord.deb
#rm discord.deb

echo "    qbittorrent..."
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
sudo apt-get update && sudo apt-get install qbittorrent 

echo "    micro"
sudo apt-get install micro

echo "    ms teams"
wget -O teams.deb https://go.microsoft.com/fwlink/p/?LinkID=2112886&clcid=0xc09&culture=en-au&country=AU
sudo apt install ./teams.deb
#rm teams.deb

echo "    zoom"
wget -O zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install ./zoom.deb
#rm zoom.deb

echo "   chromium"
sudo apt install -y chromium-browser


echo "[-] Downloading Fonts [-]"
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"


[[ -d ~/.fonts  ]] || mkdir ~/.fonts

for font_file in *.ttf
do
	mv "$font_file" ~/.fonts
	
done

sudo apt-get install ffmpeg

fc-cache -fv

echo "[-] 

#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
	echo -e "Please provide the 'user/package' argument";
fi

# e.g. jesseduffield/lazygit
LOCATION="$1"
echo "Installing latest Linux_x86_64.tar.gz from https://github.com/$LOCATION"


#LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/$LOCATION/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
#curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
#tar xf lazygit.tar.gz lazygit
#sudo install lazygit -D -t /usr/local/bin/

#!/bin/sh

function checkInstall()
{
	pid=$1;
	name=$2;

	type -P $pid &>/dev/null && echo "- $name is already installed" || {
	        read -p "Do you want to install $name? [y/n]: " install
	        if [ $install == "y" ]; then
			toinstall=("${toinstall[@]}" "$pid")
	        fi
	}
}

# imagemagick
# my bash_profile

checkInstall brew "HomeBrew"
checkInstall wget "Wget"
checkInstall node "Node.js"
checkInstall weinre "Weinre"

read -p "Do you want a bash_profle file with some cool features? [y/n]: " bash_p
if [ $bash_p == "y" ]; then
	toinstall=("${toinstall[@]}" "bash_p")
fi


echo "Those software will be installed: ${toinstall[@]}";
read -p "Let's do it now? [y/n]: " install
if [ $install == "n" ]; then
	exit;
fi


for i in "${toinstall[@]}"
do
	echo "[INSTALLING $i]"
	if [ $i == "brew" ]; then
		ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
		brew doctor;

	elif [ $i == "bash_p" ]; then
		(cd ~ && wget https://raw.github.com/erwanjegouzo/MacStuff/master/bash_profile && mv bash_profile .bash_profile);

	else
		brew install $i;
	fi
done

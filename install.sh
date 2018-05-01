#!/bin/bash

OS="$(awk '{print $1}' < /etc/issue)"
case $OS in
	elementary|Ubuntu)
		OSCAT="ubuntu";;
	arch|Arch|Antergos)
		OSCAT="arch";;
	*)
		OSCAT="hz";;
esac

if [[ $OSCAT == "ubuntu" ]]; then
	INST_CMD="apt-get install"
elif [[ $OSCAT == "arch" ]]; then
	INST_CMD="pacman -S"
else
	read -p "I can't obtain your OS. Please tell me how you install packages? Like \"apt-get install\" or \"pacman -S\": " INST_CMD
fi

echo "Ok so we install packages like \"$INST_CMD <package_name>\""

have_package() {
	return $(which $1 > /dev/null)
}

install_package() {
	echo "Installing $1..."
	eval "$INST_CMD $1"
	if (( $? == 0 )); then
		echo "Done installing $1."
		return 0
	else
		echo "An error occurred while installing $1."
		return 1
	fi
}

for i in git xclip guake firefox zsh; do
	if ! have_package $i; then
		install_package $i
	fi
done

echo "Adding aliases to .zshrc..."
echo "alias ls='ls --color=auto'" >> ~/.zshrc
echo "alias grep='grep --color=auto'" >> ~/.zshrc
echo "alias xclip='xclip -selection clipboard'" >> ~/.zshrc
echo "" >> ~/.zshrc
echo "function evnc() {" >> ~/.zshrc
echo "	nohup evince $@ > /dev/null" >> ~/.zshrc
echo "}" >> ~/.zshrc
echo "" >> ~/.zshrc

echo "Installing Oh-My-Zsh..."
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O zsh_install.sh)"
sh zsh_install.sh
rm zsh_install.sh

echo "Installing the powerlevel9k theme for OMZ..."
git clone "https://github.com/bhilburn/powerlevel9k.git" "~/.oh-my-zsh/custom/themes/powerlevel9k"
sed 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel9k\/powerlevel9k"/g' -i ~/.zshrc
echo "POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)" >> ~/.zshrc
echo "POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator battery time)" >> ~/.zshrc
echo "POWERLEVEL9K_BATTERY_LOW_BACKGROUND='240'" >> ~/.zshrc
echo "POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND='240'" >> ~/.zshrc
echo "POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND='240'" >> ~/.zshrc
echo "POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND='240'" >> ~/.zshrc

echo ""
echo "You may want to install a good font for your terminal now. You can do it:"
echo "  - here: https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#step-2-install-a-powerline-font"
echo "  - by installing noto-fonts-emoji (this package exists in AUR repositories)"
echo "Please, do it yourself"
echo ""

if [[ $OSCAT == "ubuntu" ]]; then
	if ! have_package "g++"; then
		install_package "g++"
	fi

	if ! have_package "subl"; then
		if install_package "sublime-text"; then
			echo "Copying sublime-build file for C++ ..."
			wget "https://github.com/Golovanov399/install-things/raw/master/C++ Single File.sublime-build"
			mkdir -p "~/.config/sublime-text-3/Packages/C++/"
			mv "C++ Single File.sublime-build" "~/.config/sublime-text-3/Packages/C++/"
		fi
	fi
elif [[ $OSCAT == "arch" ]]; then
	if ! have_package "yaourt"; then
		install_package "yaourt"
	fi

	if ! have_package "subl"; then
		if install_package "sublime-text-dev"; then
			echo "Copying sublime-build file for C++ ..."
			wget "https://github.com/Golovanov399/install-things/raw/master/C++ Single File.sublime-build"
			mkdir -p "~/.config/sublime-text-3/Packages/C++/"
			mv "C++ Single File.sublime-build" "~/.config/sublime-text-3/Packages/C++/"
		fi
	fi

	if ! have_package telegram; then
		install_package telegram
	fi
fi

echo "Creating precompiled headers..."
BITS_LOCATION=$(find /usr/include -name stdc++.h | head -n 1)
wget "https://github.com/Golovanov399/install-things/raw/master/precompiled-headers/script.sh"
sed "s|[^[:space:]]*stdc++.h|$BITS_LOCATION|g" -i script.sh
mkdir -p ~/misc/precompiled-headers
mv "script.sh" "~/misc/precompiled-headers/"
(cd ~/misc/precompiled-headers; sh ./script.sh)

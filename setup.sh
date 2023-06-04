#!/usr/bin/bash

## OpenBox Desktop : Setup GUI in Ubuntu Termux

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Reset terminal colors
reset_color() {
	printf '\033[37m'
}

## Reset terminal colors
reset_color() {
	printf '\033[37m'
}

## Script Termination
exit_on_signal_SIGINT() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Show usages
usage() {
	echo -e ${ORANGE}"\nInstall GUI (Openbox Desktop) on Ubuntu"
	echo -e ${ORANGE}"Usages : $(basename $0) --install"
}

## Update, chromium polybar xfconf, Program Installation
_anu=(chromium polybar xfconf )

setup_chromium() {
	echo -e ${RED}"\n[*] Installing Polybar chromium..."
        echo -e ${CYAN}"\n[*] Removing distribution provided chromium packages and dependencies..."
	{ reset_color; sudo apt remove snapd -yqq -qq && sudo apt autoremove -yqq; }
	{ reset_color; sudo apt remove chromium* -yqq && sudo apt autoremove -yqq; }
	{ reset_color; sudo apt update -qq; sudo apt install software-properties-common gnupg --no-install-recommends -y -qq; }
	echo -e ${CYAN}"\n[*] Adding Debian repo for Chromium installation... \n"
    	{ reset_color; sudo cp -rf $(pwd)/debian.list /etc/apt/sources.list.d; }
        { reset_color; sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517; }
        { reset_color; sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138; }
        { reset_color; sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50; }
        { reset_color; sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A; }
	{ reset_color; sudo apt update; }
	echo -e ${CYAN}"\n[*] Installing required programs... \n"
	for packages in "${_anu[@]}"; do
		{ reset_color; sudo apt-get install -y chromium polybar xfconf; }
		_iapt=$(apt list-installed $packages 2>/dev/null | tail -n 1)
		_checkapt=${_iapt%/*}
		if [[ "$_checkapt" == "$packages" ]]; then
			echo -e ${GREEN}"\n[*] Package $packages installed successfully.\n"
			continue
		fi
	done
    reset_color
}
## Update, X11, Program Installation
_apts=(lightdm bc bmon calc calcurse curl dbus desktop-file-utils elinks feh fontconfig-utils fsmon \
		geany git gtk2.0 gtk3.0 imagemagick jq leafpad man mpc mpd mutt ncmpcpp \
		ncurses-utils neofetch obconf openbox openssl-tool polybar ranger rofi \
        nautilus startup-notification vim wget xarchiver xbitmaps xcompmgr \
		xfce4-settings dbus-x11 xmlstarlet xorg )

setup_base() {
	echo -e ${RED}"\n[*] Installing Termux Desktop..."
	echo -e ${CYAN}"\n[*] Updating Termux Base... \n"
	{ reset_color; sudo update; sudo apt autoclean; sudo apt upgrade -y; }
	echo -e ${CYAN}"\n[*] Installing required programs... \n"
	for package in "${_apts[@]}"; do
		{ reset_color; sudo apt-get install -y "$package"; }
		{ reset_color; sudo apt-get autoremove -y; }
		_iapt=$(apt list-installed $package 2>/dev/null | tail -n 1)
		_checkapt=${_iapt%/*}
		if [[ "$_checkapt" == "$package" ]]; then
			echo -e ${GREEN}"\n[*] Package $package installed successfully.\n"
			continue
		fi
	done
	reset_color
}

## Configuration
setup_config() {
	# backup
	configs=($(ls -A $(pwd)/files))
	echo -e ${RED}"\n[*] Delete old files and dirs... "
	for file in "${configs[@]}"; do
		echo -e ${CYAN}"\n[*] Backing up $file..."
		if [[ -f "$HOME/$file" || -d "$HOME/$file" ]]; then
			{ reset_color; rm-rf ${HOME}/${file}; }
		else
			echo -e ${MAGENTA}"\n[!] $file Doesn't Exist."			
		fi
	done
	
	# Copy config files
	echo -e ${RED}"\n[*] Coping config files... "
	for _config in "${configs[@]}"; do
		echo -e ${CYAN}"\n[*] Coping $_config..."
		{ reset_color; cp -rf $(pwd)/files/$_config $HOME; }
	done
	if [[ ! -d "$HOME/Desktop" ]]; then
		mkdir $HOME/Desktop
	fi
}

## Install OpenBOX Desktop
install_td() {
	setup_chromium
	setup_base
	setup_config
}

## Main
if [[ "$1" == "--install" ]]; then
	install_td
else
	{ usage; reset_color; exit 0; }
fi
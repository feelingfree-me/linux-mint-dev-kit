#!/bin/bash
# @Author: cscmu
# @Date:   2015-08-27 17:25:32
# @Last Modified by:   Feelingfree
# @Last Modified time: 2016-10-24 15:25:13


######################################################################
# Maintenance                                                        #
######################################################################
# Change Repo To Thailand locate
sudo cp Resource/etc/apt/sources.list.d/official-package-repositories.list /etc/apt/sources.list.d/official-package-repositories.list
sudo chown -v root:root /etc/apt/sources.list.d/official-package-repositories.list
sudo chmod -v 644 /etc/apt/sources.list.d/official-package-repositories.list

# Fix Apt-get lock
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock

# Fix Duplicate Repository
sudo rm -f /etc/apt/sources.list.d/additional-repositories.list

######################################################################
# Software Manager                                                   #
######################################################################

## Add Repository
# Google Chrome Stable
sudo add-apt-repository -y "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Libre Office 5
sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-0
echo -e "Package: *\nPin: release o=LP-PPA-libreoffice-libreoffice-5-0\nPin-Priority: 701" | sudo tee /etc/apt/preferences.d/libreoffice-libreoffice-5-0.pref

# Numix
sudo add-apt-repository -y ppa:numix/ppa

# Update Repository
sudo apt-get update

# Upgrade
DEBIAN_FRONTEND="noninteractive" sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND="noninteractive" sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

######################################################################
# Application                                                        #
######################################################################

# Install xfce4 power manager plugins fix brightness control
sudo apt-get install -y xfce4-power-manager xfce4-power-manager-plugins

# Fix Numlock on Login Screen
sudo apt-get install -y numlockx

# GNOME Terminal
sudo apt-get install -y gnome-terminal

# Remove Conflict Application
sudo apt-get remove -y xfce4-terminal

# Development Tools
sudo apt-get install -y build-essential

# Git and Subversion
sudo apt-get install -y git subversion

# Python
sudo apt-get install -y python3 idle3 python3-numpy python3-scipy python3-matplotlib python3-setuptools
sudo easy_install3 pip
sudo pip3 install virtualenv

# Ruby
sudo apt-get install -y ruby

# Google Chrome
sudo apt-get install -y google-chrome-stable

# Sublime Text
sudo apt-get install -y sublime-text

# Libre Office
sudo apt-get install -y libreoffice

# Imwheel
sudo apt-get install -y imwheel

# Utility
sudo apt-get install -y zip unzip p7zip-full

# Diff Tools
sudo apt-get install -y kdiff3 meld diffuse

# Dropbox
sudo apt-get install -y nautilus-dropbox

# Uninstall Unwanted
sudo apt-get remove -y xscreensaver mint-search-addon tomboy

######################################################################
# User Interface                                                     #
######################################################################

# Windows Theme (Numix)
sudo apt-get install -y numix-gtk-theme numix-icon-theme-circle

# Update Icon Cache
sudo gtk-update-icon-cache /usr/share/icons/Numix-Circle/

######################################################################
# Patch Files                                                        #
######################################################################

# Constant
resourceDir="Resource"
dirList="dirList.txt"
fileList="fileList.txt"

# Delete Old File
sudo rm -fv $dirList
sudo rm -fv $fileList

# Generate Directory & File List
sudo find $resourceDir -type d | awk -F $resourceDir '{print $2}' | sudo tee --append $dirList
sudo find $resourceDir -type f | awk -F $resourceDir '{print $2}' | sudo tee --append $fileList

# Copy Patch Files
sudo cp -rfv "$resourceDir/." /

# Fix Directory Permission to 755
while read line;
do
    if [[ ! -z "$line" ]];
    then
        sudo chmod -v 755 "$line"
        sudo chown -v root:root "$line"
    fi
done < "$dirList"

# Fix File Permission to 644
while read line;
do
    if [[ ! -z "$line" ]];
    then
        sudo chmod -v 644 "$line"
        sudo chown -v root:root "$line"
    fi
done < "$fileList"

# Special Permission
sudo chmod -v 755 /usr/share/cscmu/xfce4-panel-reset.sh

######################################################################
# Maintenance                                                        #
######################################################################

# Fix Apt-get lock
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock

# Fix Duplicate Repository
sudo rm -f /etc/apt/sources.list.d/additional-repositories.list

# Fix Missing Package
sudo apt-get install -y --fix-missing

# Update Repository
sudo apt-get update

# Clean Apt-get
sudo apt-get -y autoremove
sudo apt-get -y clean

# Update Font Cache
sudo fc-cache -fv

# Create Swap
read -p "Create Swap file [y/n]: " -n 1 -r
if [[ !$REPLY =~ ^[Yy]$ ]]
then
    if [[ -z $(sudo cat /etc/fstab | grep swapfile) ]];
    then
        sudo fallocate -l 4G /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo "/swapfile none swap sw 0 0" | sudo tee --append /etc/fstab
    fi
fi

# Grub
sudo update-grub

######################################################################
# Initialize New Environment for Root User                           #
######################################################################

# Kill Service to Force Overwrite File
killall -SIGKILL xfdesktop
killall -SIGKILL xfce4-panel
killall -SIGKILL xfce4-power-manager
killall -SIGKILL xfce4-notifyd
killall -SIGKILL xfconfd
killall -SIGKILL xfsettingsd
gconftool-2 --shutdown

# Reset Home Directory
loginName=$(logname)

sudo rm -rfv /home/$loginName
sudo cp -rfv /etc/skel/. /home/$loginName
sudo chown -vR $loginName:$loginName /home/$loginName
sudo chmod 700 /home/$loginName

######################################################################
# Prompt                                                             #
######################################################################
read -p "Complete! Do you want to restart now [ Ctrl + C to cancel ]: " -n 1 -r
sudo reboot

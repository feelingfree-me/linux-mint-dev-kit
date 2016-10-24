#!/bin/bash

file=~/.config/xfce4/firstTime

while true;
do
    if [[ ! -e "$file" ]];
    then
        exit
    fi

    if [[ -z $(pgrep "xfce4-panel") ]];
    then
        sleep 1
        continue
    else
        /usr/bin/killall xfce4-panel
        /usr/bin/xfce4-panel  &
        sleep 2
        /usr/bin/xfce4-panel -r &

        rm $file
        exit
	fi
done
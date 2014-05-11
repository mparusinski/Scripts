#!/bin/sh

pacman -Sypwv
MESSAGE=`pacman -Quic`

if [ $MESSAGE  ]
then
    echo $MESSAGE | mail -s "Updates are available for Gullveig" root
fi

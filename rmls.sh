#!/bin/sh
# Author: David Campbell <davekong@archlinux.us>
# Last Updated: 27 Jan 2010

# Open a list of the current directory's files in $EDITOR for easy removal.

[ -z $EDITOR ] && echo "Set the EDITOR environment variable!" && exit
time=`date +%s` #UNIX timestamp
list=".rmls$time"
ls -Apv > "$list"
$EDITOR $list
xargs -a $list rm -rfI

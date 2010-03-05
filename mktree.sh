#!/bin/bash
#
# mktree.sh - create tree a diagram using tree and your filesystem.
# Created On: 07 February 2010
# Last Updated: 08 February 2010
# 
# Copyright (C) 2010 David Campbell <davekong@archlinux.us>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#		   
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

add_branches () {
	if [ $# -eq 2 ]; then
		local path="$1"
		local branches="$2"
		while [ $branches -gt 0 ]; do
			mkdir "$name/$path/$branches"
			((branches--))
		done
	elif [ $# -eq 1 ]; then
		local branches="$1"
		while [ $branches -gt 0 ]; do
			mkdir "$name/$branches"
			((branches--))
		done
	fi
}

label_branches () {
	if [ -n "$1" ]; then
		local path=$1
		local tree=($(ls "$name/$path"))
		for branch in $(seq 0 $((${#tree[*]} - 1))); do
			read -p "Label ${tree[branch]}: " 'new_name'
			mv -n "$name/$path/${tree[branch]}" "$name/$path/$new_name"
		done
	else
		local tree=($(ls "$name"))
		for branch in $(seq 0 $((${#tree[*]} - 1))); do
			read -p "Label ${tree[branch]}: " 'new_name'
			mv -n "$name/${tree[branch]}" "$name/$new_name"
		done
	fi
}

# MAIN
clear
read -p 'Enter the name of your tree: ' 'name'
if [ -d "$name" ]; then
	echo 'WARNING!!! You are editing a directory which already exists!'
else
	while [ -a "$name" ]; do
		echo "mktree: cannot create tree '$name': File exists"
		read -p 'Enter a different name: ' 'name'
	done
	[ -z "$name" ] && echo 'No name, no tree. Goodbye!' && exit
	mkdir "$name" && echo "$name has been created."
fi
echo
echo 'Enter a number from the list or enter nothing to print the list again.'
# MENU
options='add_branches label_branches print_tree quit'
select opt in $options; do
	case $opt in

		add_branches)
		echo 'Enter the node to add branches to:'
		read -p "$name/" 'node'
		read -p 'Enter the number of branches: ' 'branches'
		add_branches "$node" "$branches"
		;;

		label_branches)
		echo 'Enter a node whose branches you wish to re-label:'
		read -p "$name/" 'node'
		label_branches "$node"
		;;
		
		print_tree)
		tree -vA --noreport "$name"
		;;

		quit)
	       	echo 'Goodbye!'
		exit
		;;

		*)
		echo 'Please enter a number from the menu.'
		echo 'A blank will print the menu again.'
		;;
	esac
done

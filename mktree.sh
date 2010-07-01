#!/bin/bash
#
# mktree.sh - create tree a diagram using tree and your filesystem.
# Created On: 07 February 2010
# Last Updated: 05 March 2010
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

add_children () {
	local 'node'
	local 'children'
	echo 'Enter the node to add children to:'
	read -p "$root/" 'node'
	read -p 'Enter the number of children: ' 'children'
	if [ -n "$node" ]; then
		while [ $children -gt 0 ]; do
			mkdir "$root/$node/$children"
			((children--))
		done
	elif [ -n "$children" ]; then
		while [ $children -gt 0 ]; do
			mkdir "$root/$children"
			((children--))
		done
	fi
}

label_children () {
	local 'node'
	echo 'Enter a node whose children you wish to re-label:'
	read -p "$root/" 'node'
	if [ -n "$node" ]; then
		local children=($(ls "$root/$node"))
		for child in $(seq 0 $((${#children[*]} - 1))); do
			read -p "Label ${children[child]}: " 'new_name'
			mv -n "$root/$node/${children[child]}" "$root/$node/$new_name"
		done
	else
		local children=($(ls "$root"))
		for child in $(seq 0 $((${#children[*]} - 1))); do
			read -p "Label ${children[child]}: " 'new_name'
			mv -n "$root/${children[child]}" "$root/$new_name"
		done
	fi
}
# MAIN
clear
read -p 'Enter a label for the root of your tree: ' 'root'
if [ -d "$root" ]; then
	echo 'WARNING!!! You are editing a directory which already exists!'
else
	while [ -e "$root" ]; do
		echo "mktree: cannot create tree '$root': File exists"
		read -p 'Enter a different label: ' 'root'
	done
	[ -z "$root" ] && echo 'No root, no tree. Goodbye!' && exit
	mkdir -v "$root"
fi
echo
echo 'Enter a number from the list, or enter nothing to print the list again.'
# MENU
options='add_children label_children print_tree quit'
select opt in $options; do
	case $opt in
		add_children  ) add_children;;
		label_children) label_children;;
		print_tree    ) tree -vA --noreport "$root";;
		quit          ) echo 'Goodbye!'; exit;;
		*)
		echo 'Please enter a number from the menu.'
		echo 'A blank will print the menu again.'
		;;
	esac
done

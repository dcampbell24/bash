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
		n="$2"
		while [ $n -gt 0 ]; do
			mkdir "$name/$path/$n"
			((n--))
		done
	elif [ $# -eq 1 ]; then
		n="$1"
		while [ $n -gt 0 ]; do
			mkdir "$name/$n"
			((n--))
		done
	fi
}

label_branches () {
	if [ 0 == $no_path ]; then
		local path=$1
		shift
		while [ $# -gt 0 ]; do
			read -p "Label $1: " new_name
			mv -n "$name/$path/$1" "$name/$path/$new_name"
			shift
		done
	elif [ 1 == $no_path ]; then
		while [ $# -gt 0 ]; do
			read -p "Label $1: " new_name
			mv -n "$name/$1" "$name/$new_name"
			shift
		done
	fi
}

# MAIN
clear
read -p "Enter the name of your tree: " name
mkdir $name || \
echo -e "\nWARNING!!! You are editing a directory which already exists!\n"
# MENU
options="add_branches label_branches print_tree quit"
select opt in $options; do
	case $opt in

		add_branches)
		echo "Add n branches to node. [path/to/node] some_number"
		read "input" 
		add_branches $input
		;;

		label_branches)
		no_path=0
		echo "Label the branches of a node. path/to/node"
		read "input"
		[ -z $input ] && no_path=1
		label_branches $input `ls $name/$input`
		;;
		
		print_tree)
		tree -vA --noreport $name
		;;

		quit)
	       	echo done
		exit
		;;

		*)
		echo "Please enter a number from the menu."
		echo "A blank will print the menu again."
		;;
	esac
done
exit 0

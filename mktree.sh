#!/usr/bin/env bash

# Copyright (C) 2010 David Campbell <davekong@archlinux.us>
# This program is licensed under the GPL. See COPYING for the full license.

switch_node() {
	if [[ -d "$root/$1" ]]; then
		pushd "$root/$node" &>/dev/null
		return 0
	else
		printf "Error: node %s does not exist\n" "$node"
		return 1
	fi
}

add_children() {
	local 'node' 'children'
	echo 'Enter the node to add children to:'
	read -p "$root/" 'node'
	read -p 'Enter the number of children: ' 'children'

	if [[ -n "$node" ]]; then
		switch_node "$node" || return
	elif [[ -n "$children" ]]; then
		pushd "$root" &>/dev/null
	else
		echo "No children added."
		return
	fi

	while (( $children > 0 )); do
		mkdir "$children"
		((children--))
	done
	popd &>/dev/null
}

label_children() {
	local 'node'
	echo 'Enter a node whose children you wish to re-label:'
	read -p "$root/" 'node'

	if [[ -n "$node" ]]; then
		switch_node "$node" || return
	else
		pushd "$root" &>/dev/null
	fi

	local children=($(echo "?*"))
	for (( child=0; child < ${#children[@]}; child++ )); do
		read -p "Label ${children[child]}: " 'new_name'
		mv -Tn "${children[child]}" "$new_name"
	done
	popd &>/dev/null
}

# MAIN
clear
read -p 'Enter a label for the root of your tree: ' 'root'
if [[ -d "$root" ]]; then
	echo 'WARNING!!! You are editing a directory which already exists!'
else
	while [[ -e "$root" ]]; do
		echo "mktree: cannot create tree '$root': File exists"
		read -p 'Enter a different label: ' 'root'
	done
	[[ -z "$root" ]] && echo 'No root, no tree. Goodbye!' && exit
	mkdir "$root"
fi

# MENU
echo -e "\nEnter a number from the list, or hit ENTER to print the list again."
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

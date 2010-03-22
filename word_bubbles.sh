#!/bin/bash
#
# word_bubbles - Lets cheat playing word bubbles! 
# Author: David Campbell <davekong@archlinux.us>

# Insert the location of the dictionary to use.
# Dictionaries with common words work better (e.g. cracklib).
dict='/usr/share/dict/cracklib-small'
word_list="/tmp/words$RANDOM"

touch "$word_list"
clear
# 1) Request the three letter stem, limiting input to three characeters.
echo             "**Word Bubbles Cheat**"
read -e -n 3 -p  "Enter the three letter stem: " stem

# 2) Search for words beginning with the given stem of length stem plus
# count (count starts at one) and print the first three words encountered.
# 3) Increment count.
# 4) Repeat steps 2 and 3 until the word length equals twelve.
# 5) Add three thirteen letter plus length words.

until [ ${count:=1} -eq 10 ]; do
	grep -w -m 3 "\<$stem.\{${count}\}" "$dict" >> "$word_list"
	((count++))
done
grep -w -m 3 "\<$stem.\{10,\}" "$dict" >> "$word_list"

# 6) Print the word list sorted, without repeats, minus stem, and on one line.
sort -u "$word_list" | sed "s/^$stem//" | tr '\n' ' '
echo
rm "$word_list"
exit 0

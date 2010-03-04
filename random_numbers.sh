#!/bin/sh
#
# random_numbers - generate random numbers.
# Created On: 13 February 2010
# Last Updated:
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

# Reseed RANDOM using the script's PID.
RANDOM=$$

gen_num() {
	digits=$((10**$1))
	numbers="$2"
	while [ $numbers -gt 0 ]; do
		n=$((RANDOM % digits))
		echo -n "$n "
		((numbers--))
	done
	echo
}
gen_num $1 $2
exit 0

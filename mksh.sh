#!/bin/sh
#
# mksh - make a new shell script.
# Created On: 07 Februrary 2010
# Last Updated: 07 Februrary 2010
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

# Fill in with your own information.
author="David Campbell"
email="davekong@archlinux.us"

# Allow user to either pass a script name argument or be prompted for one.
if [ $# -eq 0 ]
then
	clear
	echo    "This is a script to ease creating a new BASH script."
	read -p "Enter a name for your script: " "name"
else
	until [ ${count:=$#} -eq 0 ]
	do
		name+=" $1"
		shift
		((count--))
	done
	name=${name:1}     # remove leading '_'
fi

# Replace spaces in the name with '_'
name=${name// /_}

# 'Here Document' creates template and saves to $name
cat > $name <<TEMPLATE
#!/bin/sh
#
# $name - description goes here.
# Created On: `date "+%d %B %Y"`
# Last Updated:
# 
# Copyright (C) `date +%Y` $author <$email>
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

# Options handling (simple), use getopts for more complexity.
while [[ \$1 == -* ]]; do
       	 case "\$1" in
           -h|--help|-\?) show_help; exit 0;;
           -v) verbose=1; shift;;
	   -o) output_file=\$2; shift 2;;
	   --) shift; break;;
	   -*) echo "invalid option: \$1"; show_help;exit 1;;
	 esac
done

exit 0
TEMPLATE

chmod u+x $name
$EDITOR $name || vi $name

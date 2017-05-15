#!/bin/bash
# @file scripts/get_alias.bash
# Reads alias definitions from CSV files and prints them in a format
# suitable for evaluation by a shell:
# eval `get_alias.bash -s` for sh-like shells,
# eval `get_alias.bash -c` for csh-like shells.
# @author Jamison Hope <jrh@theptrgroup.com>

# Make sure this file is being executed, not sourced
function issourced() {
    [[ ${FUNCNAME[@]: -1} == "source" ]]
}
if issourced
then
    echo "${BASH_SOURCE[0]} must be executed, not sourced."
    unset issourced
    return -1
fi
unset issourced

# Set up for sh/csh style
awkprog=""
awkskipcomments="NF && \$1!~/^#/"

if [ $# -eq 1 ]
then
    if [ "x$1" == "x-s" ]
    then
        # sh-like shells
        awkprog="$awkskipcomments { print \"alias \"\$1\"='\"\$2\"';\" }"
    elif [ "x$1" == "x-c" ]
    then
        # csh-like shells
        awkprog="$awkskipcomments { print \"alias \"\$1\" '\"\$2\"';\" }"
    fi
fi

if [ -z "$awkprog" ]
then
    echo echo "\"Usage: ${BASH_SOURCE[0]} [-s|-c]\""
    exit -1
fi

# Find CSV files relative to this file's location
here=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >> /dev/null; pwd)

# Set common aliases
[ -r "$here/../shared/alias.csv" ] && \
    awk -F"," "$awkprog" < "$here/../shared/alias.csv"

# Now set system-specific aliases
UNAME=$( uname -s )
HOST=$( hostname -s )

[ -r "$here/../$UNAME/alias.csv" ] \
    && awk -F"," "$awkprog" < "$here/../$UNAME/alias.csv"

[ -r "$here/../$UNAME/alias_$HOST.csv" ] \
    && awk -F"," "$awkprog" < "$here/../$UNAME/alias_$HOST.csv"

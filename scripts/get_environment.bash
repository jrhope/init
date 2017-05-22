#!/bin/bash
# @file scripts/get_environment.bash
# Reads environment variable definitions from CSV files and prints
# them in a format suitable for evaluation by a shell:
# eval `get_environment.bash -s` for sh-like shells,
# eval `get_environment.bash -c` for csh-like shells.
# PATH-like variables are assigned using prepend_path, so directories
# end up in reverse order.
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

# PATH-like variables can be listed multiple times
pathvars=(PATH
          MANPATH
          INFOPATH
          CLASSPATH
          LD_LIBRARY_PATH
          DYLD_LIBRARY_PATH
         )


# Find files relative to this file's location
here=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >>/dev/null; pwd)

# Set up for sh/csh style
awkprog=""
awkskipcomments="NF && \$1!~/^#/"

pathreg=$(IFS="|" ; echo "${pathvars[*]}")

if [ $# -eq 1 ]
then
    if [ "x$1" == "x-s" ]
    then
        # sh-like shells
        printf "source \"%s\";\n" "$here/path_functions.sh"
        printf -v awkprog "$awkskipcomments { if (\$1 ~ /^$pathreg\$/) { print \"prepend_path \"\$1\" \"\$2\";\" } else { print \"export \"\$1\"=\"\$2\";\" } }"
    elif [ "x$1" == "x-c" ]
    then
        # csh-like shells
        printf -v awkprog "$awkskipcomments { if (\$1 ~ /^$pathreg\$/) { print \"prepend_path \"\$1\" \"\$2\";\" } else { print \"setenv \"\$1\" \"\$2\";\" } }"
    fi
fi

if [ -z "$awkprog" ]
then
    echo echo "\"Usage: ${BASH_SOURCE[0]} [-s|-c]\""
    exit -1
fi


# Start with common variables
[ -r "$here/../shared/environment.csv" ] && \
    awk -F"," "$awkprog" < "$here/../shared/environment.csv"

# Now set system-specific variables
UNAME=$( uname -s )
HOST=$( hostname -s )

[ -r "$here/../$UNAME/environment.csv" ] \
    && awk -F"," "$awkprog" < "$here/../$UNAME/environment.csv"

[ -r "$here/../$UNAME/environment_$HOST.csv" ] \
    && awk -F"," "$awkprog" < "$here/../$UNAME/environment_$HOST.csv"

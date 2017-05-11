# @file scripts/path_functions.sh
# Functions to add directories to a PATH-like environment variable in
# bash.
# @author Jamison Hope <jrh@theptrgroup.com>

# Usage: append_path PATH_VARIABLE /new/path/element
# Adds /new/path/element to the end of PATH_VARIABLE if PATH_VARIABLE
# does not already contain /new/path/element.
append_path()
{
    if eval test -z "\$$1"
    then
	eval "export $1=$2"
    fi

    if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\""
    then
	eval "export $1=\$$1:$2"
    fi
}

# Usage: prepend_path PATH_VARIABLE /new/path/element
# Adds /new/path/element to the front of PATH_VARIABLE if PATH_VARIABLE
# does not already contain /new/path/element.
prepend_path()
{
    if eval test -z "\$$1"
    then
      eval "export $1=$2"
      return
    fi

    if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\""
    then
      eval "export $1=$2:\$$1"
    fi
}

# Usage: prepend_path_if_exists PATH_VARIABLE /possible/dir
# If /possible/dir is in fact a directory, calls
# prepend_path PATH_VARIABLE /possible/dir
prepend_path_if_exists()
{
    if [ -d "$2" ]
    then
        prepend_path $1 $2
    fi
}

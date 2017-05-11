# @file scripts/path_functions.csh
# Functions to add directories to a PATH-like environment variable in
# csh. Lifted from Fink's init.csh a long time ago.
# @author Jamison Hope <jrh@theptrgroup.com>

# Usage: append_path PATH_VARIABLE /new/path/element
# Adds /new/path/element to the end of PATH_VARIABLE if PATH_VARIABLE
# does not already contain /new/path/element.
alias append_path 'if ( $\!:1 !~ \!:2\:* && $\!:1 !~ *\:\!:2\:* && $\!:1 !~ *\:\!:2 && $\!:1 !~ \!:2 ) setenv \!:1 ${\!:1}\:\!:2'

# Usage: prepend_path PATH_VARIABLE /new/path/element
# Adds /new/path/element to the front of PATH_VARIABLE if PATH_VARIABLE
# does not already contain /new/path/element.
alias prepend_path 'if ( $\!:1 !~ \!:2\:* && $\!:1 !~ *\:\!:2\:* && $\!:1 !~ *\:\!:2 && $\!:1 !~ \!:2 ) setenv \!:1 \!:2\:${\!:1}; if ( $\!:1 !~ \!:2\:* ) setenv \!:1 \!:2`echo \:${\!:1} | /usr/bin/sed -e s%^\!:2\:%% -e s%:\!:2\:%:%g -e s%:\!:2\$%%`'


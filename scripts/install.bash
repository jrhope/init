#!/usr/bin/env bash
# @file scripts/install.sh
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

# Get absolute path to this file
here=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >> /dev/null; pwd)

now=$(date "+%FT%T%z")

function install_link()
{
    local fname=$(basename "$1")
    local dotname="$HOME/.$fname"
    local absd=$(cd "$(dirname "$1")" >> /dev/null; pwd)
    local lfname="${absd#$HOME/}/$fname"

    if [[ -f "$1" ]]
    then
        if [[ -f "$dotname" && ! "$dotname" -ef "$1" ]]
        then
            echo "Moved existing file '$dotname' to '$dotname.$now'"
            mv "$dotname" "$dotname.$now"
        fi

        [ -f "$dotname" ] || ln -s "$lfname" "$dotname"
    fi
}


# bash/sh/ksh files
install_link "$here/../shared/bash_profile"
install_link "$here/../shared/bashrc"
install_link "$here/../shared/bash_logout"
install_link "$here/../shared/bash_completion"
install_link "$here/../shared/profile"
install_link "$here/../shared/kshrc"

# tcsh files
install_link "$here/../shared/login"
install_link "$here/../shared/tcshrc"
install_link "$here/../shared/cshrc"
install_link "$here/../shared/logout"

# zsh files
install_link "$here/../shared/zshenv"
install_link "$here/../shared/zprofile"
install_link "$here/../shared/zshrc"
install_link "$here/../shared/zlogin"
install_link "$here/../shared/zlogout"

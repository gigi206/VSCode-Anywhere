#!/usr/bin/env bash

echo -ne "\033[1;32m"
echo "/============================================================="
echo "|"
echo "| Installation in progress, please wait, it could take a while"
echo "|"
echo "\\============================================================="
echo -e "\033[0m"

cd "$(dirname $0)"

{%- if salt['grains.get']('vscode-anywhere:profile') == 'linux_admin' %}
if [ $(id -u) -ne 0 ]
    echo "You must run this script as root (sudo)"
    sudo "$0"
    exit $?
fi
{%- endif %}

./vscode-anywhere.sh --retcode-passthrough --state-verbose=False state.apply saltenv={{ saltenv }} sync_mods=all $*
exit=$?

[ -z "${VSCode_Anywhere_CI}" ] && read -p "Press a key to exit..."

exit ${exit}

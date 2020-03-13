#!/usr/bin/env bash

# Output actions to console
function Output {
    message="${1}"
    echo -en "\\n\033[1;32m* \033[1;36m"
    eval echo '${message}'
    echo -e "\033[0m"
}

# Output errors to console
function OutputErrror {
    message="${1}"
    echo -e "\033[1;31m"
    eval echo -e '\\nError: ${message}\\n'
    echo -e "\033[0m"
    exit 1
}

# Run command inside Nixpkgs
function NsCmd {
    echo -e "\\n\\n\033[1;33m>>> ${@} <<< (NsCmd)\033[0m"
    "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'bin', 'vscode-anywhere-chroot') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'nix') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew') }}" bash << EOF
. {{ salt['grains.get']('vscode-anywhere:tools:env') }}
${@}
EOF

    if [ ${?} -ne 0 ]
    then
        OutputErrror "A critical error has occurred !"
    fi
}

echo -ne "\033[1;32m"
echo "/============================================================="
echo "|"
echo "| Update in progress, please wait, it could take a while"
echo "|"
echo "\\============================================================="
echo -e "\033[0m"

cd "$(dirname $0)"
. "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"

{%- if salt['grains.get']('vscode-anywhere:profile') == 'linux_admin' %}
if [ $(id -u) -ne 0 ]
then
    echo "You must run this script as root (sudo)"
    sudo "$0"
    exit=$?
fi
{%- endif %}

Output "Updating VSCode-Anywhere from branch {{ saltenv }}"
Output "Updating Saltstack pillar file"

NsCmd "/home/linuxbrew/.linuxbrew/bin/curl -sL -o '{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:pillar_path')) }}/saltstack.sls' https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/{{ saltenv }}/salt/conf/srv/pillar/saltstack.sls"

saltCurrentVersion="$(./vscode-anywhere.sh test.version --out txt -l quiet | cut -d ' ' -f 2)"
saltTargetVersion="$(./vscode-anywhere.sh pillar.get saltstack:version --out txt -l quiet | cut -d ' ' -f 2)"

if [ "$saltCurrentVersion" == "$saltTargetVersion" ]
then
    Output "Syncing Saltstack ${saltCurrentVersion} to the latest VSCode-Anywhere updates (fork)"
    (
        cd "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path') | path_join('src')) }}"
        # NsCmd "git reset --hard vsc${saltTargetVersion}"
        NsCmd "git fetch origin vsc${saltTargetVersion}"
        NsCmd "git pull --ff-only origin vsc${saltTargetVersion}"
    )
else
    Output "Updating Saltsatck ${saltCurrentVersion} => ${saltTargetVersion}"
    rm -fr "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path') | path_join('src')) }}"
    Output "Syncing Saltstack to the latest VSCode-Anywhere updates (fork)"
    NsCmd "git clone -b vsc${saltTargetVersion} --depth 100 https://github.com/gigi206/salt.git '{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path') | path_join('src')) }}'"
fi

Output "Updating VSCode-Anywhere"
./vscode-anywhere.sh --retcode-passthrough --state-verbose=False state.apply salt/utils/update saltenv={{ saltenv }} sync_mods=all $*
exit=$?

[ -z "${VSCode_Anywhere_CI}" ] && read -p "Press a key to exit..."

exit ${exit}

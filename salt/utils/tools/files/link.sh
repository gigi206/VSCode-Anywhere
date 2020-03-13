#!/usr/bin/env bash

# Output actions to console
function Output {
    message="${1}"
    echo -en "\\n\033[1;32m* \033[1;36m"
    eval echo '${message}'
    echo -e "\033[0m"
}

function salt-call {
"{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'bin', 'vscode-anywhere-chroot')) }}" "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'nix')) }}" "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew')) }}" bash << EOF
    test -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" && source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    test -f /home/linuxbrew/.linuxbrew/bin/brew && eval ${brew_shellenv}
    "${HOME}/.nix-profile/bin/nix-shell" '{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) | path_join('nixpkgs', 'profiles', 'salt.nix') }}' --run "salt-call --config-dir='${config_dir_offline}' --log-file='${log_file}' --pillar-root='${pillar_root}' $*"
EOF
}

echo -ne "\033[1;32m"
echo "/============================================================="
echo "|"
echo "| Compute link in progress, please wait, it could take a while"
echo "|"
echo "\\============================================================="
echo -e "\033[0m"

cd "$(dirname $0)"

export HOME="$(realpath {{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) | path_join('vscode-anywhere', 'home') }})"
brew_shellenv='$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)'

{%- if salt['grains.get']('vscode-anywhere:profile') == 'linux_admin' %}
if [ $(id -u) -eq 0 ]
then
    echo "You must run this script as root (sudo)"
    sudo "$0"
    exit $?
fi
{%- endif %}

Output "Reset env"
rm -f env.sh

Output "Build offline config file"
config_dir="{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}"
config_dir_offline="{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}-offline"
config_file="${config_dir_offline}/minion.d/VSCode-Anywhere-offline.conf"
log_file="{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}/var/log/salt/minion"
pillar_root="{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:pillar_path')) }}"
root_dir="$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}/var/cache/salt/minion/files/{{ saltenv }})"

mkdir -p "${config_dir_offline}/minion.d"
cp "${config_dir}/grains" "${config_dir_offline}/grains"
cp "${config_dir}/minion" "${config_dir_offline}/minion"

cat << EOF > "${config_file}"
file_client: local
fileserver_backend:
- roots
id: VSCode-Anywhere
top_file_merging_strategy: same
root_dir: ${root_dir}
file_roots:
  {{saltenv}}:
  - ${root_dir}
EOF

Output "Installing grains => vscode-anywhere:path"
salt-call grains.set "vscode-anywhere:path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:path')) }})"

Output "Installing grains => vscode-anywhere:apps:path"
salt-call grains.set "vscode-anywhere:apps:path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }})"

Output "Installing grains => vscode-anywhere:tools:path"
salt-call grains.set "vscode-anywhere:tools:path" "$(realpath $(dirname $0))"

Output "Installing grains => vscode-anywhere:tools:env"
salt-call grains.set "vscode-anywhere:tools:env" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }})"

Output "Installing grains => vscode-anywhere:config:path"
salt-call grains.set "vscode-anywhere:config:path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:config:path')) }})"

Output "Installing grains => vscode-anywhere:saltstack:path"
salt-call grains.set "vscode-anywhere:saltstack:path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }})"

Output "Installing grains => vscode-anywhere:saltstack:config_path"
salt-call grains.set "vscode-anywhere:saltstack:config_path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }})"

Output "Installing grains => vscode-anywhere:saltstack:minion_path"
salt-call grains.set "vscode-anywhere:saltstack:minion_path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:minion_path')) }})"

Output "Installing grains => vscode-anywhere:saltstack:roots_path"
salt-call grains.set "vscode-anywhere:saltstack:roots_path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:roots_path')) }})"

Output "Installing grains => vscode-anywhere:saltstack:pillar_path"
salt-call grains.set "vscode-anywhere:saltstack:pillar_path" "$(realpath $(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:pillar_path')) }})"

cp "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), '${config_dir_offline}/grains') }}" "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), '${config_dir}/grains') }}"

Output "Check the current installation (offline)"
salt-call --retcode-passthrough --state-verbose=False state.apply pillar=\'{\"vscode-anywhere\": {\"offline\": True}}\' sync_mods=all saltenv={{ saltenv }} $*
exit=$?

[ -z "${VSCode_Anywhere_CI}" ] && read -p "Press a key to exit..."

exit ${exit}

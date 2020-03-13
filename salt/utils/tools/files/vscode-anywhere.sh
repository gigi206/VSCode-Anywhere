#!/usr/bin/env bash

{%- if salt['grains.get']('vscode-anywhere:profile') == 'linux_admin' %}
if [ $(id -u) -eq 0 ]
then
    "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'bin', 'vscode-anywhere-chroot')) }}" "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'nix')) }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew') }}" bash << EOF
    . "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
    nix-shell "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'profiles', 'salt.nix')) }}" --run "salt-call --config-dir='{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}' $*"
EOF
    exit=$?
else
    echo "You must run this script as root (sudo)"
    sudo "$0"
    exit $?
fi
{% else %}
"{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'bin', 'vscode-anywhere-chroot') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'nix') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew') }}" bash << EOF
    . "{{ salt['grains.get']('vscode-anywhere:tools:env') }}"
    nix-shell "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'profiles', 'salt.nix') }}" --run "salt-call --config-dir='{{ salt['grains.get']('vscode-anywhere:saltstack:config_path') }}' $*"
EOF
exit=$?
{%- endif %}

exit ${exit}

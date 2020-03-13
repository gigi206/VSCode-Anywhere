{%- from 'salt/core/terminal/map.jinja' import terminal with context -%}
#!/usr/bin/env bash

cd "$(dirname $0)"

"{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'bin', 'vscode-anywhere-chroot') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'nix') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew') }}" bash <<EOF
    . "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
    "{{ terminal.path }}" $*
EOF
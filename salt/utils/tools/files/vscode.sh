{%- from 'salt/core/vscode/map.jinja' import vscode with context -%}
#!/usr/bin/env bash

"{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'bin', 'vscode-anywhere-chroot') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'nix') }}" "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('linuxbrew') }}" bash << EOF
    . "{{ salt['grains.get']('vscode-anywhere:tools:env') }}"
    ("{{ vscode.path }}" --user-data-dir "{{ vscode.user_dir }}" --extensions-dir "{{ vscode.extensions_dir }}" $*)&
    # FIXME: workaround to avoid killing vscode when namespace is finished
    sleep 9999999999999999999999
EOF

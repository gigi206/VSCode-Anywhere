{%- from 'salt/core/nix/map.jinja' import nix with context %}

{%- if nix.enabled and salt['grains.get']('kernel') != 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':env.sls' }}:
  file.append:
    - name: {{ salt['grains.get']('vscode-anywhere:tools:env') }}
    - makedirs: True
    - text:
      # - source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      # - source "$(dirname $0)/{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) | path_join('vscode-anywhere', 'home', '.nix-profile', 'etc', 'profile.d', 'nix.sh') }}"
      - test -f "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.nix-profile', 'etc', 'profile.d', 'nix.sh') }}" && source "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.nix-profile', 'etc', 'profile.d', 'nix.sh') }}"


{{ salt['vscode_anywhere.get_id'](sls) + ':bashrc' }}:
  file.symlink:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.bashrc') }}
    - target: {{ salt['grains.get']('vscode-anywhere:tools:env') }}
    - force: True
    - makedirs: True
    - mode: 755
{%- endif %}

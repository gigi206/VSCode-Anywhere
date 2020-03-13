{%- from 'salt/core/nix/map.jinja' import nix with context %}


{%- if nix.enabled and salt['grains.get']('kernel') != 'Windows' %}

{{ salt['vscode_anywhere.get_id'](sls) + ':nixpkgs:nix' }}:
  file.directory:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'nix') }}
    - dir_mode: 755


{#-
{{ salt['vscode_anywhere.get_id'](sls) + ':nixpkgs:home' }}:
  file.directory:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home') }}
    - dir_mode: 755
#}


{{ salt['vscode_anywhere.get_id'](sls) + ':nixpkgs:conf' }}:
  file.directory:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'conf') }}
    - dir_mode: 755


{{ salt['vscode_anywhere.get_id'](sls) + ':nixpkgs:profiles' }}:
  file.directory:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'profiles') }}
    - dir_mode: 755


{{ salt['vscode_anywhere.get_id'](sls) + ':bootstrap' }}:
  cmd.run:
    - name: curl https://nixos.org/nix/install | bash
    - unless:
      - test -L {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.nix-profile') }}
{%- endif %}
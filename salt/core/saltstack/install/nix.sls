{%- from 'salt/core/saltstack/map.jinja' import saltstack with context %}

{%- if saltstack.enabled and salt['grains.get']('kernel') != 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('nixpkgs', 'profiles', 'salt.nix') }}
    - backup: False
    - makedirs: True
    - source: salt://salt/conf/nix/profiles/salt.nix
{%- endif %}
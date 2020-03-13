{%- from 'salt/core/nix/map.jinja' import nix with context %}


include:
  # - salt/utils/sync
  - salt/core/nix/install


{{ salt['vscode_anywhere.get_id'](sls) + ':channels' }}:
  nix.channel_updated:
    - name: nixpkgs
  {%- if sls != 'salt/core/nix/install' %}
    - require:
      - sls: salt/core/nix/install
  {%- endif %}


{%- if nix.enabled and nix.upgrade %}
{{ salt['vscode_anywhere.get_id'](sls) + ':upgrade' }}:
  nix.pkg_latest:
    - name: '*'
    # - require:
    #   - sls: salt/utils/sync
  {%- if sls != 'salt/core/nix/install' %}
    - require:
      - sls: salt/core/nix/install
  {%- endif %}
{%- endif %}
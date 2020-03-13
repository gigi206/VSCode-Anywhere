{%- from 'salt/core/brew/map.jinja' import brew with context %}


include:
  # - salt/utils/sync
  - salt/core/brew/install


{%- if brew.enabled and brew.upgrade %}
{{ salt['vscode_anywhere.get_id'](sls) + ':upgrade' }}:
  pkg.uptodate:
    - name: '*'
    - refresh: True
    - provider: mac_brew_pkg
    # - require:
    #   - sls: salt/utils/sync
  {%- if sls != 'salt/core/brew/install' %}
    - require:
      - sls: salt/core/brew/install
  {%- endif %}
{%- endif %}
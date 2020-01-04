{%- from 'salt/core/msys2/map.jinja' import msys2 with context %}
{%- from 'salt/core/scoop/map.jinja' import scoop with context %}


include:
  # - salt/utils/sync
  - salt/core/msys2/install

# Hold msys2 package. Just run uptodate.sls to have the last packages version
{%- if msys2.enabled %}
{{ salt['vscode_anywhere.get_id'](sls) }}:
  scoop.pkg_holded:
    - name: msys2
    - path: {{ scoop.path }}
    - require:
      # - sls: salt/utils/sync
      - sls: salt/core/msys2/install
{%- endif %}
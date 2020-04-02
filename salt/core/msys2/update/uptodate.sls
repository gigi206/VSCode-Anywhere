{%- from 'salt/core/msys2/map.jinja' import msys2 with context %}


{%- if msys2.enabled and msys2.upgrade %}
include:
  # - salt/utils/sync
  - salt/core/msys2/install


{{ salt['vscode_anywhere.get_id'](sls) }}:
  msys2.pkg_uptodate:
    - name: Update all packages
    - refresh: True
    - shell_path: {{ msys2.shell_path }}
    - shell_args: {{ msys2.shell_args }}
    - require:
      # - sls: salt/utils/sync
      - sls: salt/core/msys2/install
{%- endif %}
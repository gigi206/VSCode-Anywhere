{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{%- if salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/zeal/install

{{ salt['vscode_anywhere.get_id'](sls) }}:
  cmd.run:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') }} --unregister
    - require:
      - sls: salt/core/zeal/install
    - onlyif:
      - if ("{{ salt['reg.read_value']('HKCU', 'Software\Classes\dash-plugin\shell\open\command')['success'] }}" -eq "False") { exit 1 }
{%- endif %}
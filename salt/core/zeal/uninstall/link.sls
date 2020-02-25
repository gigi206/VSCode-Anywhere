{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{%- if salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/zeal/install

{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.absent:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Documentation.lnk') }}
{%- endif %}
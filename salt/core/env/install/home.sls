{%- from 'salt/core/env/map.jinja' import env with context %}

{%- if env.enabled and salt['grains.get']('kernel') != 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':home' }}:
  file.directory:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home') }}
    - dir_mode: 755
{%- endif %}
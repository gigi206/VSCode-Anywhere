{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{%- if zeal.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/zeal/install

{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.shortcut:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Documentation.lnk') }}
    - target: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') }}
    # - working_dir: {{ salt['cmd.run']("$([Environment]::GetFolderPath('Desktop'))", shell='powershell') }}
    - description: Zeal Documentation
    - icon_location: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') }},0
    - require:
      - sls: salt/core/zeal/install
{%- endif %}
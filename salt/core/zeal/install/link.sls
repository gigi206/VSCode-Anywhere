{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{%- if zeal.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/zeal/install

{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.shortcut:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Documentation.lnk') }}
    # Don't target on the Zeal binary because Zeal need to have the vcredist2019-portable path in his $env:Path
    - target: {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('zeal.ps1') }}
    # - working_dir: {{ salt['cmd.run']("$([Environment]::GetFolderPath('Desktop'))", shell='powershell') }}
    - description: Zeal Documentation
    - icon_location: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') }},0
    - require:
      - sls: salt/core/zeal/install
{%- endif %}
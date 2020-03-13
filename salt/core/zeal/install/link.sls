{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{%- if zeal.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/zeal/install


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.shortcut:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Documentation.lnk') }}
    # Don't target on the Zeal binary because Zeal need to have the vcredist2019-portable path in his $env:Path
    - target: {{ salt['cmd.run']("powershell (Get-Command -ErrorAction 'SilentlyContinue' powershell).Path") }}
    - arguments: -noprofile -executionpolicy bypass -file {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('zeal.ps1') }}
    # - working_dir: {{ salt['cmd.run']("$([Environment]::GetFolderPath('Desktop'))", shell='powershell') }}
    - description: Zeal Documentation
    - icon_location: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') }},0
    - require:
      - sls: salt/core/zeal/install
{%- else %}
include:
  - salt/core/zeal/install


{{ salt['vscode_anywhere.get_id'](sls) + ':icon' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'zeal.png') }}
    - source: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'home', '.nix-profile', 'share', 'icons', 'hicolor', '128x128', 'apps', 'zeal.png' ) }}
    - makedirs: True
    - mode: 644
    - backup: False
    - require:
      - sls: salt/core/zeal/install


{%- if salt['pillar.get']('vscode-anywhere:linux:install_desktop_files', False) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut:user' }}:
  file.managed:
    - name: {{ salt['user.info'](salt['grains.get']('username'))['home'] | path_join('.local', 'share','applications', 'Zeal.desktop') }}
    - mode: 755
    - makedirs: True
    - backup: False
    - contents: |
        [Desktop Entry]
        Version=1.0
        Name=Zeal
        GenericName=Documentation Browser
        Comment=VSCode-Anywhere documentation
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('documentation.sh') }} %u
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'zeal.png') }}
        Terminal=false
        Type=Application
        Categories=Development;
        MimeType=x-scheme-handler/dash;x-scheme-handler/dash-plugin;
{%- endif %}


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Zeal.desktop') }}
    # - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'shortcuts', 'Zeal.desktop') }}
    - mode: 755
    # - makedirs: True
    - backup: False
    - contents: |
        [Desktop Entry]
        Version=1.0
        Name=Zeal
        GenericName=Documentation Browser
        Comment=Simple API documentation browser
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('documentation.sh') }} %u
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'zeal.png') }}
        Terminal=false
        Type=Application
        Categories=Development;
        MimeType=x-scheme-handler/dash;x-scheme-handler/dash-plugin;
{%- endif %}
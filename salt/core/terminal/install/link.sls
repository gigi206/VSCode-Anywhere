{%- from 'salt/core/terminal/map.jinja' import terminal with context %}

{%- if terminal.enabled  %}
include:
  - salt/core/terminal/install


{%- if salt['grains.get']('kernel') == 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':terminus:shortcut' }}:
  file.shortcut:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Terminal.lnk') }}
    - target: {{ salt['cmd.run']("powershell (Get-Command -ErrorAction 'SilentlyContinue' powershell).Path") }}
    - arguments: -noprofile -executionpolicy bypass -file {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('terminal.ps1') }}
    # - working_dir: {{ salt['cmd.run']("$([Environment]::GetFolderPath('Desktop'))", shell='powershell') }}
    - description: Terminal
    - icon_location: {{ terminal.path }},0
    - require:
      - sls: salt/core/terminal/install

{%- else %}

{{ salt['vscode_anywhere.get_id'](sls) + ':icon' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'terminal.png') }}
    - source: https://github.com/Eugeny/terminus/raw/master/build/icons/512x512.png
    - makedirs: True
    - mode: 644
    - backup: False
    - skip_verify: True
    - require:
      - sls: salt/core/terminal/install


{%- if salt['pillar.get']('vscode-anywhere:linux:install_desktop_files', False) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut:user' }}:
  file.managed:
    - name: {{ salt['user.info'](salt['grains.get']('username'))['home'] | path_join('.local', 'share', 'applications', 'Terminal.desktop') }}
    - mode: 755
    - makedirs: True
    - backup: False
    - contents: |
        [Desktop Entry]
        Name=Terminal
        Comment=VScode-Anywhere Terminal
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('terminal.sh') }} %U
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'terminal.png') }}
        Terminal=false
        Type=Application
        Categories=TerminalEmulator;
{%- endif %}


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Terminal.desktop') }}
    # - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'shortcuts', 'Terminal.desktop') }}
    - mode: 755
    # - makedirs: True
    - backup: False
    - contents: |
        [Desktop Entry]
        Name=Terminal
        Comment=Terminal for VSCode-Anywhere
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('terminal.sh') }} %U
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'terminal.png') }}
        Terminal=false
        Type=Application
        Categories=TerminalEmulator;
{%- endif %}
{%- endif %}
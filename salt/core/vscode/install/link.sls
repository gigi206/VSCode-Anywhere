{%- from 'salt/core/vscode/map.jinja' import vscode with context %}


{%- if vscode.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/chocolatey/install
  - salt/core/vscode/install


{{ salt['vscode_anywhere.get_id'](sls) + ':binary' }}:
  cmd.run:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('chocolatey', 'tools', 'shimgen.exe') }} -p {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'vscode', 'current', 'Code.exe') }} -i {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'vscode', 'current', 'Code.exe') }} -c '--user-data-dir {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'vscode', 'user') }} --extensions-dir {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'vscode', 'extensions') }}' -o {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'shims', 'VSCode-Anywhere.exe') }}
    - shell: powershell
    - require:
      - sls: salt/core/chocolatey/install
      - sls: salt/core/vscode/install
    - unless:
      - if (!(Test-Path '{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'shims', 'VSCode-Anywhere.exe') }}' -PathType Leaf)) { exit 1 }


{{ salt['vscode_anywhere.get_id'](sls) + ':binary:update' }}:
  cmd.run:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('chocolatey', 'tools', 'shimgen.exe') }} -p {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'vscode', 'current', 'Code.exe') }} -i {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'vscode', 'current', 'Code.exe') }} -c '--user-data-dir {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'vscode', 'user') }} --extensions-dir {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'vscode', 'extensions') }}' -o {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'shims', 'VSCode-Anywhere.exe') }}
    - shell: powershell
    - require:
      - sls: salt/core/chocolatey/install
      - sls: salt/core/vscode/install
    - onchanges:
      - scoop: {{ (vscode.scoop.pkgs.keys() | list)[0] }}


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.shortcut:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('VSCode-Anywhere.lnk') }}
    - target: {{ salt['cmd.run']("powershell (Get-Command -ErrorAction 'SilentlyContinue' powershell).Path") }}
    - arguments: -noprofile -executionpolicy bypass -file {{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.ps1') }}
    # - working_dir: {{ salt['cmd.run']("$([Environment]::GetFolderPath('Desktop'))", shell='powershell') }}
    - description: VSCode-Anywhere
    - icon_location: {{ vscode.icon }}
    - require:
      - sls: salt/core/vscode/install

{%- else %}

include:
  - salt/core/vscode/install


{{ salt['vscode_anywhere.get_id'](sls) + ':icon' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'code.png') }}
    - source: {{ vscode.icon }}
    - makedirs: True
    - mode: 644
    - backup: False
    - require:
      - sls: salt/core/vscode/install


{%- if salt['pillar.get']('vscode-anywhere:linux:install_desktop_files', False) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut:user' }}:
  file.managed:
    - name: {{ salt['user.info'](salt['grains.get']('username'))['home'] | path_join('.local', 'share','applications', 'VSCode-Anywhere.desktop') }}
    - mode: 755
    - makedirs: True
    - backup: False
    - contents: |
        [Desktop Entry]
        Type=Application
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.sh') }}
        Terminal=false
        Name=VSCode-Anywhere
        Categories=Utility;TextEditor;Development;IDE;
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'code.png') }}
        Comment=Code Editing. Redefined.
        GenericName=Text Editor
        MimeType=text/plain;inode/directory;
        StartupNotify=true
        StartupWMClass=Code
        Actions=new-empty-window;
        Keywords=vscode;

        [Desktop Action new-empty-window]
        Name=New Empty Window
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.sh') }} --new-window %F
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'code.png') }}
{%- endif %}


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('VSCode-Anywhere.desktop') }}
    # - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'shortcuts', 'VSCode-Anywhere.desktop') }}
    - mode: 755
    # - makedirs: True
    - backup: False
    - contents: |
        [Desktop Entry]
        Type=Application
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.sh') }}
        Terminal=false
        Name=VSCode-Anywhere
        Categories=Utility;TextEditor;Development;IDE;
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'code.png') }}
        Comment=Code Editing. Redefined.
        GenericName=Text Editor
        MimeType=text/plain;inode/directory;
        StartupNotify=true
        StartupWMClass=Code
        Actions=new-empty-window;
        Keywords=vscode;

        [Desktop Action new-empty-window]
        Name=New Empty Window
        Exec={{ salt['grains.get']('vscode-anywhere:tools:path') | path_join('vscode.sh') }} --new-window %F
        Icon={{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'icons', 'code.png') }}
{%- endif %}
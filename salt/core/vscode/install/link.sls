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
    - icon_location: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'vscode', 'current', 'Code.exe') }},0
    - require:
      - sls: salt/core/vscode/install
{%- endif %}
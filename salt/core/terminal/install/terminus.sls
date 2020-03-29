{%- from 'salt/core/terminal/map.jinja' import terminal with context %}


{%- if terminal.enabled %}
include:
  # - salt/utils/sync
  - salt/core/terminal/install


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


{{ salt['vscode_anywhere.get_id'](sls) + ':terminus:config.yaml' }}:
  file.managed:
    - name: {{ terminal.config_path }}
    - source: salt://salt/core/terminal/template/terminus.yaml
    - template: jinja
    - makedirs: True
    - backup: False
    - defaults:
      terminal: {{ terminal | json }}
{%- endif %}
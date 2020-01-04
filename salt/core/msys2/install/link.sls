{%- from 'salt/core/msys2/map.jinja' import msys2 with context %}


{%- if msys2.enabled %}
include:
  - salt/core/msys2/install


{{ salt['vscode_anywhere.get_id'](sls) + ':shortcut' }}:
  file.shortcut:
    - name: {{ salt['grains.get']('vscode-anywhere:path') | path_join('Terminal.lnk') }}
    - target: {{ msys2.terminal_path }}
    # - working_dir: {{ salt['cmd.run']("$([Environment]::GetFolderPath('Desktop'))", shell='powershell') }}
    - description: MSYS2 Terminal
    - icon_location: {{ msys2.terminal_path }},0
    - require:
      - sls: salt/core/msys2/install
{%- endif %}
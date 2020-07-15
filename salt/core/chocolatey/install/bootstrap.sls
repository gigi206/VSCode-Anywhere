{%- from 'salt/core/chocolatey/map.jinja' import chocolatey with context %}


{%- if chocolatey.enabled and salt['grains.get']('kernel') == 'Windows' %}

{{ salt['vscode_anywhere.get_id'](sls) + ':bootstrap' }}:
  cmd.run:
    - name: $env:ChocolateyInstall="{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('chocolatey') }}"; $env:chocolateyToolsLocation="{{ salt['grains.get']('vscode-anywhere:apps:path') }}"; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    - shell: powershell
    - env:
      - chocolateyInstall: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('chocolatey') }}
      - chocolateyToolsLocation: {{ salt['grains.get']('vscode-anywhere:apps:path') }}
    - unless:
      - IF NOT EXIST "{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('chocolatey') }}" exit 1
      #- if (!(Test-Path '{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('chocolatey') }}' -PathType Container)) { exit 1 }
      #- fun: file.access
      #  path: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('chocolatey') }}
      #  mode: f
{%- endif %}
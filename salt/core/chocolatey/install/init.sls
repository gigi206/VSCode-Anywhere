{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/chocolatey/map.jinja' import chocolatey with context %}


{%- if chocolatey.enabled %}
{{ salt['vscode_anywhere.get_id'](sls) + ':bootstrap' }}:
  cmd.run:
    - name: iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    - shell: powershell
    - env:
      - ChocolateyInstall: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey') }}
      - ChocolateyToolsLocation: {{ salt['grains.get']('vscode-anywhere:apps:path') }}
    - unless:
      - if (!(Test-Path '{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey') }}' -PathType Container)) { exit 1 }
{%- endif %}


{#- {{ init(chocolatey, action='install', func=[], include=['salt/core/chocolatey/install/env']) }} #}
{{ init(chocolatey, action='install', func=['env']) }}
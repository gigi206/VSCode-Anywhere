{%- from 'salt/core/scoop/map.jinja' import scoop with context %}


{%- if scoop.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/scoop/install/policy
  # - salt/core/scoop/install/env


{{ salt['vscode_anywhere.get_id'](sls) }}:
  cmd.run:
    - name: Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    - shell: powershell
    - require:
      - sls: salt/core/scoop/install/policy
      # - sls: salt/core/scoop/install/env
    - unless:
      - if (!(Test-Path '{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop') }}' -PathType Container)) { exit 1 }
{%- endif %}
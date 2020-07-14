{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{%- if zeal.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/zeal/install

{{ salt['vscode_anywhere.get_id'](sls) }}:
  cmd.run:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') }} --register
    - shell: powershell
    - require:
      - sls: salt/core/zeal/install
    - unless:
      - powershell -NonInteractive -NoProfile "if (!({{ salt['reg.read_value']('HKCU', 'Software\Classes\dash-plugin\shell\open\command')['vdata'] | json | replace('"', "'") }}.StartsWith({{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') | json | replace('"', "'") }}))) { exit 1 }" || exit 1
      #- if (!({{ salt['reg.read_value']('HKCU', 'Software\Classes\dash-plugin\shell\open\command')['vdata'] | json }}.StartsWith({{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') | json }}))) { exit 1 }
      #- fun: cmd.run
      #  cmd: if (!({{ salt['reg.read_value']('HKCU', 'Software\Classes\dash-plugin\shell\open\command')['vdata'] | json }}.StartsWith({{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'zeal', 'current', 'zeal.exe') | json }}))) { exit 1 }
      #  python_shell: True
      #  shell: powershell
{%- endif %}
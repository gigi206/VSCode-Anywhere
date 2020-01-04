{%- from 'salt/core/chocolatey/map.jinja' import chocolatey with context %}


{%- if chocolatey.enabled and salt['grains.get']('kernel') == 'Windows' %}

{%- set PATH = salt['reg.read_value']('HKEY_CURRENT_USER', 'Environment', 'Path')['vdata'].split(';') | unique %}
{%- set ENV_PATH = salt['environ.item']('Path')['Path'].split(';') | unique %}

{%- if salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey', 'bin') not in PATH %}
{{ salt['vscode_anywhere.get_id'](sls) + ':registry:Path' }}:
  environ.setenv:
    - name: Path
    - value: {{ '{};{}'.format(salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey', 'bin'), PATH | join(';')) }}
    - update_minion: False
    - permanent: True
{%- endif %}


{%- if salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey', 'bin') not in ENV_PATH %}
{{ salt['vscode_anywhere.get_id'](sls) + ':env:Path' }}:
  environ.setenv:
    - name: Path
    - value: {{ '{};{}'.format(salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey', 'bin'), ENV_PATH | join(';')) }}
    - update_minion: True
    - permanent: False
{%- endif %}


{{ salt['vscode_anywhere.get_id'](sls) + ':ChocolateyInstall' }}:
  environ.setenv:
    - name: ChocolateyInstall
    - value: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('Chocolatey') }}
    - update_minion: True
    - permanent: True


{{ salt['vscode_anywhere.get_id'](sls) + ':ChocolateyToolsLocation' }}:
  environ.setenv:
    - name: ChocolateyToolsLocation
    - value: {{ salt['grains.get']('vscode-anywhere:apps:path') }}
    - update_minion: True
    - permanent: True
{%- endif %}
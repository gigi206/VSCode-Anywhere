{%- from 'salt/core/scoop/map.jinja' import scoop with context %}


{%- if scoop.enabled and salt['grains.get']('kernel') == 'Windows' %}

{%- set PATH = salt['reg.read_value']('HKEY_CURRENT_USER', 'Environment', 'Path')['vdata'].split(';') | unique %}
{%- set ENV_PATH = salt['environ.item']('Path')['Path'].split(';') | unique %}

{%- if salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'shims') not in PATH %}
{{ salt['vscode_anywhere.get_id'](sls) + ':Path' }}:
  environ.setenv:
    - name: Path
    - value: {{ '{};{}'.format(salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'shims'), PATH | join(';')) }}
    - update_minion: False
    - permanent: True
{%- endif %}


{%- if salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'shims') not in ENV_PATH %}
{{ salt['vscode_anywhere.get_id'](sls) + ':Path' }}:
  environ.setenv:
    - name: Path
    - value: {{ '{};{}'.format(salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'shims'), ENV_PATH | join(';')) }}
    - update_minion: True
    - permanent: False
{%- endif %}


{{ salt['vscode_anywhere.get_id'](sls) + ':SCOOP' }}:
  environ.setenv:
    - name: SCOOP
    - value: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop') }}
    - update_minion: True
    - permanent: True
{%- endif %}
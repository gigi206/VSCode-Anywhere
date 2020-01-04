{%- from 'salt/core/msys2/map.jinja' import msys2 with context %}


{%- if msys2.enabled and salt['grains.get']('kernel') == 'Windows' %}

{%- set PATH = salt['reg.read_value']('HKEY_CURRENT_USER', 'Environment', 'Path')['vdata'].split(';') | unique %}
{%- set ENV_PATH = salt['environ.item']('Path')['Path'].split(';') | unique %}

{%- if salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'usr', 'bin') not in PATH
    or salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw32', 'bin') not in PATH
    or salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw64', 'bin') not in PATH %}
{{ salt['vscode_anywhere.get_id'](sls) + ':registry:Path' }}:
  environ.setenv:
    - name: Path
    - value: {{ '{};{};{};{}'.format(salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw64', 'bin'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw32', 'bin'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'usr', 'bin'), PATH | join(';')) }}
    - update_minion: False
    - permanent: True
{%- endif %}


{%- if salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'usr', 'bin') not in ENV_PATH
    or salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw32', 'bin') not in ENV_PATH
    or salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw64', 'bin') not in ENV_PATH %}
{{ salt['vscode_anywhere.get_id'](sls) + ':env:Path' }}:
  environ.setenv:
    - name: Path
    - value: {{ '{};{};{};{}'.format(salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw64', 'bin'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'mingw32', 'bin'), salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'msys2', 'current', 'usr', 'bin'), ENV_PATH | join(';')) }}
    - update_minion: True
    - permanent: False
{%- endif %}


  {%- if salt['grains.get']('install_type') == 'vscode-anywhere:windows_portable' %}
    {%- set MSYSTEM = 'MSYS' %}
  {%- else %}
    {%- set MSYSTEM = 'MINGW64' %}
  {%- endif %}

{{ salt['vscode_anywhere.get_id'](sls) + ':MSYSTEM' }}:
  environ.setenv:
    - name: MSYSTEM
    - value: {{ MSYSTEM }}
    - update_minion: True
    - permanent: True
{%- endif %}
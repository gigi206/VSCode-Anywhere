{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/vscode/map.jinja' import vscode with context %}

{%- if grains['kernel'] == 'Windows' %}
  {%- set func = ['scoop', 'extensions', 'settings', 'keybindings'] %}
{%- else %}
  {%- set func = ['nix', 'brew', 'extensions', 'settings', 'keybindings'] %}
{%- endif %}

{%- if grains['kernel'] == 'Linux' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':uninstall:vscode'}}:
  nix.pkg_removed:
    - name: {{ vscode.vscode_pkg_uninstall }}
{%- endif %}

{{ init(vscode,
  action='install',
  func=func,
  include=['salt/core/vscode/install/locale', 'salt/core/vscode/install/link']) }}
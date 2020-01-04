{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/vscode/map.jinja' import vscode with context %}

{{ init(vscode, action='install', func=['scoop', 'extensions', 'settings', 'keybindings'], include=['salt/core/vscode/install/locale', 'salt/core/vscode/install/link']) }}
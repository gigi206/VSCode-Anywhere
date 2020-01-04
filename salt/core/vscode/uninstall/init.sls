{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/vscode/map.jinja' import vscode with context %}

{{ init(vscode, action='uninstall') }}
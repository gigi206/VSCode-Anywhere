{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/vscode/map.jinja' import vscode with context %}

{{ init(vscode, action='update') }}
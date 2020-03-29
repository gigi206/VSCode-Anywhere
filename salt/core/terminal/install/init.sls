{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/terminal/map.jinja' import terminal with context %}

{{ init(terminal, action='install', include=['salt/core/terminal/install/terminus']) }}
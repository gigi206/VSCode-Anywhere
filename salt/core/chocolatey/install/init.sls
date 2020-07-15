{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/chocolatey/map.jinja' import chocolatey with context %}


{#- {{ init(chocolatey, action='install', func=[], include=['salt/core/chocolatey/install/env']) }} #}
{{ init(chocolatey, action='install', func=['env'], include=['salt/core/chocolatey/install/bootstrap']) }}
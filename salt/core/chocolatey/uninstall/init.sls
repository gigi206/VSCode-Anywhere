{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/chocolatey/map.jinja' import chocolatey with context %}

{{ init(chocolatey, action='uninstall', func=[]) }}
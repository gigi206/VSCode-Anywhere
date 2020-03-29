{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/scoop/map.jinja' import scoop with context %}

{{ init(scoop, action='uninstall') }}
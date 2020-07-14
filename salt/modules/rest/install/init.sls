{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/rest/map.jinja' import rest with context %}


{{ init(rest, action='install') }}
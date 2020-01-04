{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/saltstack/map.jinja' import saltstack with context %}

{{ init(saltstack, action='install') }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/saltstack/map.jinja' import saltstack with context %}

{{ init(saltstack, action='update', include=['salt/core/saltstack/install/config']) }}
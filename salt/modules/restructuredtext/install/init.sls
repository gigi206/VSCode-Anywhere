{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/restructuredtext/map.jinja' import restructuredtext with context %}


{{ init(restructuredtext, action='install', include=['salt/modules/restructuredtext/install/pip']) }}
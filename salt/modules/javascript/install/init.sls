{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/javascript/map.jinja' import javascript with context %}


{{ init(javascript, action='install', include=['salt/modules/javascript/install/npm']) }}
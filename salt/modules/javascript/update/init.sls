{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/javascript/map.jinja' import javascript with context %}


{{ init(javascript, action='update', include=['salt/modules/javascript/update/npm']) }}
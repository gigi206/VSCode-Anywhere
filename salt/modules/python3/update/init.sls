{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/python3/map.jinja' import python3 with context %}


{{ init(python3, action='update', include=['salt/modules/python3/update/pip']) }}
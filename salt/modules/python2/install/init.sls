{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/python2/map.jinja' import python2 with context %}


{{ init(python2, action='install', include=['salt/modules/python2/install/pip']) }}
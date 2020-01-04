{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/restructuredtext/map.jinja' import restructuredtext with context %}


{{ init(restructuredtext, action='update', include=['salt/modules/restructuredtext/update/pip']) }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/go/map.jinja' import go with context %}


{{ init(go, action='update', include=['salt/modules/go/update/module']) }}
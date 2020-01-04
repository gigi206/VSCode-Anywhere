{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/go/map.jinja' import go with context %}


{{ init(go, action='uninstall', include=['salt/modules/go/uninstall/module']) }}
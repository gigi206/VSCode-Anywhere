{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{{ init(zeal, action='uninstall', include=['salt/core/zeal/uninstall/unregister', 'salt/core/zeal/uninstall/link']) }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/zeal/map.jinja' import zeal with context %}

{{ init(zeal, action='install', include=['salt/core/zeal/install/register', 'salt/core/zeal/install/link']) }}
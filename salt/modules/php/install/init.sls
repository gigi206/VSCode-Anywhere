{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/php/map.jinja' import php with context %}


{{ init(php, action='install', include=['salt/modules/php/install/extensions', 'salt/modules/php/install/composer', 'salt/modules/php/install/xdebug']) }}
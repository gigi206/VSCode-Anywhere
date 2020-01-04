{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/php/map.jinja' import php with context %}


{{ init(php, action='update', include=['salt/modules/php/update/composer']) }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/java/map.jinja' import java with context %}


{{ init(java, action='uninstall') }}
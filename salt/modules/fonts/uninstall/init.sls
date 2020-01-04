{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/fonts/map.jinja' import fonts with context %}


{{ init(fonts, action='uninstall', include=['salt/modules/fonts/uninstall/fonts']) }}
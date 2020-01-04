{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/fonts/map.jinja' import fonts with context %}


{{ init(fonts, action='update', include=['salt/modules/fonts/install/fonts']) }}
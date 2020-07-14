{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/platformio/map.jinja' import platformio with context %}


{{ init(platformio, action='install') }}
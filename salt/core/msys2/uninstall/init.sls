{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/msys2/map.jinja' import msys2 with context %}

{{ init(msys2, action='uninstall') }}
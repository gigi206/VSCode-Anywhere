{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/bash/map.jinja' import bash with context %}


{{ init(bash, action='uninstall') }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/deepcode/map.jinja' import deepcode with context %}


{{ init(deepcode, action='update') }}
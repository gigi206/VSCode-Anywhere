{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/custom/map.jinja' import custom with context %}

{{ init(custom, action='install') }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/csharp/map.jinja' import csharp with context %}


{{ init(csharp, action='update') }}
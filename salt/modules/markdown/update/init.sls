{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/markdown/map.jinja' import markdown with context %}


{{ init(markdown, action='update') }}
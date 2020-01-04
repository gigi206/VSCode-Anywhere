{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/html/map.jinja' import html with context %}


{{ init(html, action='update') }}
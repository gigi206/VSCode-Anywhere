{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/rust/map.jinja' import rust with context %}


{{ init(rust, action='update', include=['salt/modules/rust/update/components']) }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/rust/map.jinja' import rust with context %}


{#- {{ init(rust, action='uninstall', include=['salt/modules/rust/uninstall/components']) }} #}
{{ init(rust, action='uninstall') }}
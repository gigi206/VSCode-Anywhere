{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/ansible/map.jinja' import ansible with context %}


{#- {{ init(ansible, action='uninstall', include=['salt/modules/ansible/uninstall/pip']) }} #}
{{ init(ansible, action='uninstall') }}
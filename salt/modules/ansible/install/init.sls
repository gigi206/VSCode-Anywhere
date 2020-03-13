{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/ansible/map.jinja' import ansible with context %}


{#- {{ init(ansible, action='install', include=['salt/modules/ansible/install/pip']) }} #}
{{ init(ansible, action='install') }}
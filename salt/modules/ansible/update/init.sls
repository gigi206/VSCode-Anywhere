{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/ansible/map.jinja' import ansible with context %}


{#- {{ init(ansible, action='update', include=['salt/modules/ansible/update/pip']) }} #}
{{ init(ansible, action='update') }}
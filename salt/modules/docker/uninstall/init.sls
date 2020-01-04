{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/docker/map.jinja' import docker with context %}


{{ init(docker, action='uninstall') }}
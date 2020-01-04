{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/remote/map.jinja' import remote with context %}


{{ init(remote, action='update') }}
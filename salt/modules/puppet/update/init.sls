{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/puppet/map.jinja' import puppet with context %}


{#- {{ init(puppet, action='update', include=['salt/modules/puppet/update/gem']) }} #}
{{ init(puppet, action='update') }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/puppet/map.jinja' import puppet with context %}


{{ init(puppet, action='uninstall', include=['salt/modules/puppet/uninstall/gem']) }}
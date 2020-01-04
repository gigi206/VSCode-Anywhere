{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{{ init(ruby, action='uninstall', include=['salt/modules/ruby/uninstall/gem']) }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{#- {{ init(ruby, action='uninstall', include=['salt/modules/ruby/uninstall/gem', 'salt/modules/ruby/uninstall/brew_gem']) }} #}
{{ init(ruby, action='uninstall', include=['salt/modules/ruby/uninstall/gem']) }}
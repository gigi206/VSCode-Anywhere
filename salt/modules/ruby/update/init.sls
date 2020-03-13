{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{#- {{ init(ruby, action='update', include=['salt/modules/ruby/update/gem', 'salt/modules/ruby/update/brew_gem']) }} #}
{{ init(ruby, action='update', include=['salt/modules/ruby/update/gem']) }}
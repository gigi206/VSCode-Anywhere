{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/ruby/map.jinja' import ruby with context %}


{%- if salt['grains.get']('kernel') == 'Windows' %}
{{ init(ruby, action='install', include=['salt/modules/ruby/install/ridk', 'salt/modules/ruby/install/gem']) }}
{%- else %}
{{ init(ruby, action='install', include=['salt/modules/ruby/install/gem']) }}
{%- endif %}
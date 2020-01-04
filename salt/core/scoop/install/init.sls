{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/scoop/map.jinja' import scoop with context %}

{#- {{ init(scoop, action='install', func=[], include=['salt/core/scoop/install/env', 'salt/core/scoop/install/policy', 'salt/core/scoop/install/bootstrap', 'salt/core/scoop/install/buckets']) }} #}
{{ init(scoop, action='install', func=['env'], include=['salt/core/scoop/install/policy', 'salt/core/scoop/install/bootstrap', 'salt/core/scoop/install/buckets']) }}
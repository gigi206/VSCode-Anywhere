{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/brew/map.jinja' import brew with context %}

{{ init(brew, action='install', func=['env'], include=['salt/core/brew/install/bootstrap', 'salt/core/brew/install/env']) }}
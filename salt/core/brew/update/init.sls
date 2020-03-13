{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/brew/map.jinja' import brew with context %}

{{ init(brew, action='update', func=['env'], include=['salt/core/brew/install/bootstrap', 'salt/core/brew/update/uptodate']) }}
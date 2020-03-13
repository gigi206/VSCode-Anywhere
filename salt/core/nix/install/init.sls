{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/nix/map.jinja' import nix with context %}

{#-
{{ init(nix, action='install', func=['env'], include=['salt/core/nix/install/bootstrap', 'salt/core/nix/install/env', 'salt/core/nix/install/link']) }}
#}
{{ init(nix, action='install', include=['salt/core/nix/install/bootstrap', 'salt/core/nix/install/env']) }}
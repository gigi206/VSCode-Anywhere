{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/nix/map.jinja' import nix with context %}

{{ init(nix, action='update', func=['env'], include=['salt/core/nix/install/bootstrap', 'salt/core/nix/update/uptodate']) }}
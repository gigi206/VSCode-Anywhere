{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/nix/map.jinja' import nix with context %}

{{ init(nix, action='uninstall', func=[]) }}
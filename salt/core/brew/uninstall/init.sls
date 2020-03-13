{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/brew/map.jinja' import brew with context %}

{{ init(brew, action='uninstall', func=[]) }}
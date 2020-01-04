{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/git/map.jinja' import git with context %}

{{ init(git, action='uninstall') }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/core/git/map.jinja' import git with context %}

{{ init(git, action='update') }}
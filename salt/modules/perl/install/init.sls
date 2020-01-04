{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/perl/map.jinja' import perl with context %}


{{ init(perl, action='install', include=['salt/modules/perl/install/cpan']) }}
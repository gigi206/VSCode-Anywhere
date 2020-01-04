{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/perl/map.jinja' import perl with context %}


{{ init(perl, action='update', include=['salt/modules/perl/update/cpan']) }}
{%- from 'salt/utils/init.jinja' import init with context %}
{%- from 'salt/modules/perl/map.jinja' import perl with context %}


{# {{ init(perl, action='uninstall', include=['salt/modules/perl/uninstall/cpan']) }} #}
{{ init(perl, action='uninstall') }}
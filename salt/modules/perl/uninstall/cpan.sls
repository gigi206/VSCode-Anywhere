{%- from 'salt/modules/perl/map.jinja' import perl with context %}


include:
  - salt/modules/perl/install


{%- set options = perl.cpan.opts.global %}
{%- do options.update(perl.cpan.opts.uninstall) %}

{%- for pkg, pkg_attr in perl.cpan.pkgs.items() %}
  {%- do options.update(pkg_attr.opts.uninstall) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cpan.removed:
    - name: {{ pkg }}
    {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/perl/install
{%- endfor %}
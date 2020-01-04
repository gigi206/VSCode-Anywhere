{%- from 'salt/modules/perl/map.jinja' import perl with context %}


{%- if perl.enabled %}
include:
  - salt/modules/perl/install


  {%- set options = perl.cpan.opts.global %}
  {%- do options.update(perl.cpan.opts.install) %}

  {%- for pkg, pkg_attr in perl.cpan.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- do options.update(pkg_attr.opts.install) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cpan.installed:
    {%- if pkg_attr.get('version') %}
    - name: {{ pkg_attr.get('version') }}
    {%- else %}
    - name: {{ pkg }}
    {%- endif %}
  {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
  {%- endfor %}
    - require:
      - sls: salt/modules/perl/install
    {%- endif %}
  {%- endfor %}
{%- endif %}
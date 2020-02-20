{%- from 'salt/modules/perl/map.jinja' import perl with context %}


{%- if perl.enabled %}
include:
  - salt/modules/perl/install


  {%- set options = perl.cpan.opts.global %}
  {%- do options.update(perl.cpan.opts.get('update')) %}

  {%- for pkg, pkg_attr in perl.cpan.pkgs.items() %}
    {%- if pkg_attr.get('enabled') %}
      {%- set options_tmp = salt['defaults.deepcopy'](options) %}
      {%- do options_tmp.update(pkg_attr.opts.get('update')) %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(pkg) }}:
  cpan.uptodate:
    {%- if pkg_attr.get('version') %}
    - name: {{ pkg_attr.get('version') }}
    {%- else %}
    - name: {{ pkg }}
    {%- endif %}
    {%- for opt, opt_attr in options_tmp.items() %}
    - {{ opt }}: {{ opt_attr }}
    {%- endfor %}
    - require:
      - sls: salt/modules/perl/install
    {%- endif %}
  {%- endfor %}
{%- endif %}
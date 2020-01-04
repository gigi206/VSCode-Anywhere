{%- from 'salt/modules/php/map.jinja' import php with context %}


{%- if php.enabled %}
include:
  - salt/modules/php/install


  {%- set options = php.composer.opts.global %}
  {%- do options.update(php.composer.opts.install) %}

{{ salt['vscode_anywhere.get_id'](sls) + ':composer.json' }}:
  file.managed:
    - name: {{ php.composer.json }}
    - makedirs: True
    - contents: |
        {
            "require": {
            {%- for pkg, pkg_attr in php.composer.pkgs.items() %}
              {%- if pkg_attr.get('enabled') %}
                {%- if loop.last %}
                "{{ pkg }}": "{{ pkg_attr.get('version', '@stable') }}"
                {%- else %}
                "{{ pkg }}": "{{ pkg_attr.get('version', '@stable') }}",
                {%- endif %}
              {%- endif %}
            {%- endfor %}
            }
        }


{{ salt['vscode_anywhere.get_id'](sls) + ':install' }}:
  composer.installed:
    - name: {{ salt['file.dirname'](php.composer.json) }}
  {%- for opt, opt_attr in options.items() %}
    - {{ opt }}: {{ opt_attr }}
  {%- endfor %}
    - require:
      - sls: salt/modules/php/install
  {#-
    - unless:
  {%- for pkg, pkg_attr in php.composer.pkgs.items() %}
    {%- if salt['grains.get']('kernel') == 'Windows' and pkg_attr.get('enabled') %}
      - powershell -Command { if (!(Test-Path '{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'persist', 'composer', 'install', 'vendor', pkg) }}' -PathType Container)) { exit 1 } }
    {%- endif %}
  {%- endfor %}
  #}
{%- endif %}
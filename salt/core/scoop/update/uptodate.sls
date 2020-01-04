{%- from 'salt/core/scoop/map.jinja' import scoop with context %}


include:
  # - salt/utils/sync
  - salt/core/scoop/install


{{ salt['vscode_anywhere.get_id'](sls) + ':buckets' }}:
  scoop.buckets_uptodate:
    - name: Update all buckets
    - path: {{ scoop.path }}
  {%- if sls != 'salt/core/scoop/install' %}
    - require:
      - sls: salt/core/scoop/install
  {%- endif %}


{%- if scoop.enabled and scoop.upgrade %}
{{ salt['vscode_anywhere.get_id'](sls) + ':packages' }}:
  scoop.pkg_uptodate:
    - name: Update all packages
    - path: {{ scoop.path }}
    # - require:
    #   - sls: salt/utils/sync
  {%- if sls != 'salt/core/scoop/install' %}
    - require:
      - sls: salt/core/scoop/install
  {%- endif %}
{%- endif %}
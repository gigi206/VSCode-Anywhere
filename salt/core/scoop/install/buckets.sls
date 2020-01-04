{%- from 'salt/core/scoop/map.jinja' import scoop with context %}


{%- if scoop.enabled and salt['grains.get']('kernel') == 'Windows' %}
include:
  - salt/core/scoop/install/bootstrap


{%- for bucket in scoop.buckets %}
{{ salt['vscode_anywhere.get_id'](sls) + ':{}'.format(bucket) }}:
  scoop.bucket_added:
    - name: {{ bucket }}
    - path: {{ scoop.path }}
    - require:
      - sls: salt/core/scoop/install/bootstrap
{%- endfor %}
{%- endif %}
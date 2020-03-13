{%- from 'salt/modules/python2/map.jinja' import python2 with context %}

{%- if python2.enabled %}

include:
  - salt/modules/python2/install


{%- if python2.anaconda_update and grains['kernel'] == 'Linux' %}

{{ salt['vscode_anywhere.get_id'](sls) + ':conda' }}:
  cmd.run:
    - name: /home/linuxbrew/.linuxbrew/opt/anaconda2/bin/conda update --yes conda
    - unless:
      - test "$(/home/linuxbrew/.linuxbrew/opt/anaconda2/bin/conda update --json --dry-run conda | jq '.actions.LINK')" = 'null'
    - require:
      - pkg: anaconda2
      - pkg: jq


{{ salt['vscode_anywhere.get_id'](sls) + ':anaconda' }}:
  cmd.run:
    - name: /home/linuxbrew/.linuxbrew/opt/anaconda2/bin/conda update --yes anaconda
    - unless:
      - test "$(/home/linuxbrew/.linuxbrew/opt/anaconda2/bin/conda update --json --dry-run anaconda | jq '.actions.LINK')" = 'null'
    - require:
      - pkg: anaconda2
      - pkg: jq

{%- endif %}
{%- endif %}
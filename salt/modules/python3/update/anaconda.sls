{%- from 'salt/modules/python3/map.jinja' import python3 with context %}

{%- if python3.enabled %}

include:
  - salt/modules/python3/install


{%- if python3.anaconda_update and grains['kernel'] == 'Linux' %}

{{ salt['vscode_anywhere.get_id'](sls) + ':conda' }}:
  cmd.run:
    - name: /home/linuxbrew/.linuxbrew/opt/anaconda3/bin/conda update --yes conda
    - unless:
      - test "$(/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/conda update --json --dry-run conda | jq '.actions.LINK')" = 'null'
    - require:
      - pkg: anaconda3
      - pkg: jq


{{ salt['vscode_anywhere.get_id'](sls) + ':anaconda' }}:
  cmd.run:
    - name: /home/linuxbrew/.linuxbrew/opt/anaconda3/bin/conda update --yes anaconda
    - unless:
      - test "$(/home/linuxbrew/.linuxbrew/opt/anaconda3/bin/conda update --json --dry-run anaconda | jq '.actions.LINK')" = 'null'
    - require:
      - pkg: anaconda3
      - pkg: jq

{%- endif %}
{%- endif %}
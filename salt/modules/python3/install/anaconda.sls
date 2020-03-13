{%- from 'salt/modules/python3/map.jinja' import python3 with context %}

{%- if python3.enabled %}

include:
  - salt/modules/python3/install
{%- if salt['grains.get']('kernel') == 'Linux' and salt['pillar.get']('vscode-anywhere:python3:anaconda', False) %}
  - salt/modules/python3/update/anaconda


{{ salt['vscode_anywhere.get_id'](sls) + ':formula' }}:
  file.managed:
    - name: /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/anaconda3.rb
    - source: salt://salt/modules/python3/files/anaconda3.rb
    - backup: False
    - require_in:
      - id: salt:modules:python3:install:anaconda3
      # - pkg: anaconda3 # buggy...

{{ salt['vscode_anywhere.get_id'](sls) + ':pin' }}:
  cmd.run:
    - name: brew pin anaconda3
    - onlyif:
        - test -L /home/linuxbrew/.linuxbrew/opt/anaconda3
        - ! test -L /home/linuxbrew/.linuxbrew/var/homebrew/pinned/anaconda3
    - require:
      - pkg: anaconda3
      - id: salt:modules:python3:install:anaconda3

{%- endif %}
{%- endif %}
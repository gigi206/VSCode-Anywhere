{%- from 'salt/modules/python2/map.jinja' import python2 with context %}

{%- if python2.enabled %}

include:
  - salt/modules/python2/install
{%- if salt['grains.get']('kernel') == 'Linux' and salt['pillar.get']('vscode-anywhere:python2:anaconda', False) %}
  - salt/modules/python2/update/anaconda


{{ salt['vscode_anywhere.get_id'](sls) + ':formula' }}:
  file.managed:
    - name: /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/anaconda2.rb
    - source: salt://salt/modules/python2/files/anaconda2.rb
    - backup: False
    - require_in:
      - id: salt:modules:python2:install:anaconda2
      # - pkg: anaconda2 # buggy...


{{ salt['vscode_anywhere.get_id'](sls) + ':pin' }}:
  cmd.run:
    - name: brew pin anaconda2
    - onlyif:
      - test -L /home/linuxbrew/.linuxbrew/opt/anaconda2
      - ! test -L /home/linuxbrew/.linuxbrew/var/homebrew/pinned/anaconda2
    - require:
      # - id: salt:modules:python2:install:anaconda2
      - pkg: anaconda2

{%- endif %}
{%- endif %}
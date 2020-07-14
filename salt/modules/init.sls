include:
    - salt/modules/vscode
    - salt/modules/fonts
    - salt/modules/git
    - salt/modules/saltstack
    - salt/modules/remote
    - salt/modules/python2
    - salt/modules/python3
    - salt/modules/ruby
    - salt/modules/perl
    - salt/modules/c_cpp
    - salt/modules/csharp
    - salt/modules/bash
    - salt/modules/go
    - salt/modules/java
    - salt/modules/php
    - salt/modules/javascript
    - salt/modules/html
    - salt/modules/powershell
    - salt/modules/docker
    - salt/modules/ansible
    - salt/modules/puppet
    - salt/modules/markdown
    - salt/modules/restructuredtext
    - salt/modules/deepcode
    - salt/modules/platformio
    - salt/modules/custom
{%- if salt['state.sls_exists']('vscode-anywhere') %}
    - vscode-anywhere
{%- endif %}
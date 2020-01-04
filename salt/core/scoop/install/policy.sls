{%- from 'salt/core/scoop/map.jinja' import scoop with context %}


{%- if scoop.enabled and salt['grains.get']('kernel') == 'Windows' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':Policy' }}:
  reg.present:
    - name: HKEY_CURRENT_USER\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell
    - vname: ExecutionPolicy
    - vdata: RemoteSigned
    - vtype: REG_SZ
{%- endif %}
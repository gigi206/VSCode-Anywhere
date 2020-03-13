{%- from 'salt/core/misc/map.jinja' import misc with context %}


{%- if misc.enabled and salt['grains.get']('vscode-anywhere:profile') == 'linux_user' %}
{{ salt['vscode_anywhere.get_id'](sls) + ':vscode-anywhere-chroot' }}:
  file.managed:
    - name: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('vscode-anywhere', 'bin', 'vscode-anywhere-chroot') }}
    - source: https://github.com/gigi206/VSCode-Anywhere/raw/{{ saltenv }}/bin/linux/vscode-anywhere-chroot-linux-x86_64
    - source_hash: md5=f0494faefbcf21f9bb9850a5ecc1820b
    # git lfs doesn't work with salt://
    # - source: salt://bin/linux/vscode-anywhere-chroot-linux-x86_64
    - backup: False
{%- endif %}
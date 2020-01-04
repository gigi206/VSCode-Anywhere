# Code below will be uncommented in future release
# https://docs.saltstack.com/en/develop/ref/states/all/salt.states.saltutil.html
# sync_all:
#   saltutil.sync_all:
#     - refresh: True

{{ salt['vscode_anywhere.get_id'](sls) }}:
  module.run:
    - name: saltutil.sync_all
    - refresh: True
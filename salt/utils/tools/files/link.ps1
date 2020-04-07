# Output actions to console
function Output([string]$msg, [bool]$newline=$true, [string]$fgcolor='Cyan', [bool]$star=$true) {
    if (${star}) { Write-Host "* " -nonewline -ForegroundColor Green }
    if (${newline}) { Write-Host "${msg}" -ForegroundColor ${fgcolor} }
    else { Write-Host -nonewline "${msg}" -ForegroundColor ${fgcolor} }
}

Write-Host ""                                                               -ForegroundColor Green
Write-Host "/=============================================================" -ForegroundColor Green
Write-Host "|"                                                              -ForegroundColor Green
Write-Host "| Compute link in progress, please wait, it could take a while" -ForegroundColor Green
Write-Host "|"                                                              -ForegroundColor Green
Write-Host "\=============================================================" -ForegroundColor Green
Write-Host ""

Set-ExecutionPolicy Bypass -Scope Process -Force
Set-Location "${PSScriptRoot}"

# Env vars
${env:Path} = (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}\scoop\shims").Path + ";${env:Path}"
${env:SCOOP} = (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}\scoop").Path

{%- if salt['grains.get']('vscode-anywhere:profile') == 'windows_admin' %}
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "You must execute this script with the administrator rights"
    $process = Start-Process -PassThru -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb "RunAs"
    $exit = ${process}.ExitCode
}
{%- endif %}

Write-Host "* Reset env" -ForegroundColor Cyan
New-Item -Path .\env.ps1 -ItemType "file" -Force | Out-Null

Write-Host "* Build offline config file" -ForegroundColor Cyan
$config_dir = "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}"
$config_dir_offline = "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}-offline"
$config_file = "${config_dir_offline}\minion.d\VSCode-Anywhere-offline.conf"
$log_file = "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\var\log\salt\minion"
$pillar_root = "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:pillar_path')) }}"
$root_dir = (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\var\cache\salt\minion\files\{{ saltenv }}").Path
New-Item -ItemType Directory -Force -Path "${config_dir_offline}\minion.d" | Out-Null
Copy-Item -Path "${config_dir}\grains" -Destination "${config_dir_offline}\grains" -Force
Copy-Item -Path "${config_dir}\minion" -Destination "${config_dir_offline}\minion" -Force

New-Item -Path "${config_file}" -ItemType "file" -Force | Out-Null
Add-Content -Path "${config_file}" -Value "file_client: local"
Add-Content -Path "${config_file}" -Value "fileserver_backend:"
Add-Content -Path "${config_file}" -Value "- roots"
Add-Content -Path "${config_file}" -Value "id: VSCode-Anywhere"
Add-Content -Path "${config_file}" -Value "top_file_merging_strategy: same"
Add-Content -Path "${config_file}" -Value "root_dir: ${root_dir}"
Add-Content -Path "${config_file}" -Value "file_roots:"
Add-Content -Path "${config_file}" -Value "  {{saltenv}}:"
Add-Content -Path "${config_file}" -Value "  - ${root_dir}"

# & .\vscode-anywhere.ps1 --log-file="$log_file" state.single file.serialize "$config_file" formatter=yaml merge_if_exists=True dataset="{'fileserver_backend': ['roots'], 'file_root': null, 'file_roots': {'salt': ['$root_dir']} }"

Write-Host "* Reconfigure scoop" -ForegroundColor Cyan
& scoop reset *
& scoop update

Output "Installing grains => vscode-anywhere:path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:path')) }}").Path

Output "Installing grains => vscode-anywhere:apps:path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:apps:path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:apps:path')) }}").Path

Output "Installing grains => vscode-anywhere:tools:path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:tools:path" (Resolve-Path "${PSScriptRoot}").Path

Output "Installing grains => vscode-anywhere:tools:env"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:tools:env" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}").Path

Output "Installing grains => vscode-anywhere:config:path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:config:path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:config:path')) }}").Path

Output "Installing grains => vscode-anywhere:saltstack:path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:saltstack:path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}").Path

Output "Installing grains => vscode-anywhere:saltstack:config_path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:saltstack:config_path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:config_path')) }}").Path

Output "Installing grains => vscode-anywhere:saltstack:minion_path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:saltstack:minion_path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:minion_path')) }}").Path

Output "Installing grains => vscode-anywhere:saltstack:roots_path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:saltstack:roots_path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:roots_path')) }}").Path

Output "Installing grains => vscode-anywhere:saltstack:pillar_path"
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" grains.set "vscode-anywhere:saltstack:pillar_path" (Resolve-Path "${PSScriptRoot}\{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:pillar_path')) }}").Path

Copy-Item -Path "${config_dir_offline}\grains" -Destination "${config_dir}\grains" -Force

Write-Host "* Check the current installation (offline)" -ForegroundColor Cyan
& "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:saltstack:path')) }}\salt-call.bat" --config-dir="${config_dir_offline}" --log-file="${log_file}" --pillar-root="${pillar_root}" --retcode-passthrough --state-verbose=False state.apply pillar='{"vscode-anywhere": {"offline": True}}' sync_mods=all saltenv={{ saltenv }} $Args
$exit = ${LASTEXITCODE}

if (!(${env:VSCode_Anywhere_CI})) { Pause }

exit ${exit}
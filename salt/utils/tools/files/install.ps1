Write-Host ""                                                               -ForegroundColor Green
Write-Host "/=============================================================" -ForegroundColor Green
Write-Host "|"                                                              -ForegroundColor Green
Write-Host "| Installation in progress, please wait, it could take a while" -ForegroundColor Green
Write-Host "|"                                                              -ForegroundColor Green
Write-Host "\=============================================================" -ForegroundColor Green
Write-Host ""                                                               -ForegroundColor Green

Set-ExecutionPolicy Bypass -Scope Process -Force
Set-Location "${PSScriptRoot}"

{%- if salt['grains.get']('vscode-anywhere:profile') == 'windows_admin' %}
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    . "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
    .\vscode-anywhere.ps1 --retcode-passthrough --state-verbose=False state.apply saltenv={{ saltenv }} sync_mods=all $Args --force-color
    $exit = $?
}
else {
    Write-Host "You must execute this script with the administrator rights"
    $run = Start-Process -NoNewWindow -PassThru -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit $run.ExitCode
}
{%- else %}
. "{{ salt['vscode_anywhere.relpath'](salt['grains.get']('vscode-anywhere:tools:path'), salt['grains.get']('vscode-anywhere:tools:env')) }}"
.\vscode-anywhere.ps1 --retcode-passthrough --state-verbose=False state.apply saltenv={{ saltenv }} sync_mods=all $Args --force-color
$exit = $?
{%- endif %}

if (!(${env:VSCode_Anywhere_CI})) { Pause }

exit ${exit}
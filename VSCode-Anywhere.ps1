##############
#   Params   #
##############
Param(
    [string]$Gitenv = "master",
    [string]$InstallDir = "C:\VSCode-Anywhere",
    [string]$SaltVersion = "3000",
    [string]$Profile = "windows_user"
)

# Output header
function Header([string]$text) {
    Write-Host ""                                                               -ForegroundColor Green
    Write-Host "/=============================================================" -ForegroundColor Green
    Write-Host "|"                                                              -ForegroundColor Green
    Write-Host "| ${text}"                                                      -ForegroundColor Green
    Write-Host "|"                                                              -ForegroundColor Green
    Write-Host "\=============================================================" -ForegroundColor Green
    Write-Host ""                                                               -ForegroundColor Green
}

# Output actions to console
function Output([string]$msg, [bool]$newline=$true, [string]$fgcolor='Cyan', [bool]$star=$true) {
    if (${star}) { Write-Host "* " -nonewline -ForegroundColor Green }
    if (${newline}) { Write-Host "${msg}" -ForegroundColor ${fgcolor} }
    else { Write-Host -nonewline "${msg}" -ForegroundColor ${fgcolor} }
}

# Output errors to console
function OutputErrror([string]$msg, [bool]$newline=$true, [bool]$exit=$true, [int]$exit_code=1) {
    if (${exit}) { ${message} = "A critical error has occurred : ${msg}" }
    else { ${message} = "An error has occurred (not critical) : ${msg}" }

    if (${newline}) { Write-Host "${message}" -ForegroundColor Red }
    else { Write-Host -nonewline "${message}" -ForegroundColor Red }

    if (${exit}) {
        if (!(${env:VSCode_Anywhere_CI})) { Pause }
        exit ${exit_code}
    }
}

function Init() {
    Header "VSCode-Anywhere"
    Output "Environment          : ${Gitenv}"
    # Output "Saltstack version   : ${SaltVersion}"
    Output "Installation profile : ${Profile}"
    Output "Installation dir     : ${InstallDir}"

    if (Test-Path "${InstallDir}" -PathType Container) {
        OutputErrror "Installation directory ${InstallDir} already exists !"
    }

    if ("${Profile}" -eq "windows_admin") {
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        if (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
            Write-Host "${Profile} means that you need to execute this script with the administrator rights"
            Start-Process -NoNewWindow -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"${PSCommandPath}`"" -Verb RunAs
            exit
        }
    }
    # FIXME
    # else {
    #     # Create user for APPVEYOR CI
    #     if (${env:VSCode_Anywhere_CI}) {
    #         $username = "saltstack"
    #         $password = ConvertTo-SecureString "S@ltstack!1" -AsPlainText -Force
    #         New-LocalUser -Name "${username}" -Password ${password}
    #         $credential = New-Object System.Management.Automation.PSCredential "${username}", ${password}
    #         Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"${PSCommandPath}`"" -Credential ${credential}
    #         exit
    #     }
    # }
}

# Extract with 7-zip
function 7zipExtract ([string]$source, [string]$target, [string]$delete=$true) {
    try {
        Output "Extracting ${source} => ${target}"
        $process = Start-Process -Wait -PassThru -NoNewWindow -WorkingDirectory "${target}" -FilePath "7z.exe" -ArgumentList "x `"${source}`" -y"

        # Delete archive if delete=$true
        if (${delete}) { Remove-Item -Path "${source}" }

        # Exit if failed
        if (${process}.ExitCode -eq 1 ) {
            OutputErrror "Failed to extract ${source} => ${target}"
        }
    }
    catch {
        OutputErrror "failed to extract : $_"
    }
}


# Reload Path environment
function ReloadPathEnv {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Install Scoop
function InstallScoop {
    Header "Scoop"
    Output "Installing Scoop"
    $env:SCOOP = "${Apps}\scoop"
    Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name SCOOP -Value "${Apps}\scoop"
    try {
        Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
        scoop update
        ReloadPathEnv
    }
    catch {
        OutputErrror "failed to install Scoop : $_"
    }
}

# Install 7-zip
function Install7zip {
    Header "7-Zip"
    Output "Installing 7-Zip"
    try {
        scoop install 7zip
    }
    catch {
        OutputErrror "failed to install 7-Zip : $_"
    }
}

# Install Git
function InstallGit {
    Header "Git"
    Output "Installing git"
    try {
        scoop install git
    }
    catch {
        OutputErrror "failed to install git : $_"
    }
}

# Install Saltstack
function InstallSaltstack {
    Header "Saltstack"
    try {
        # Download Saltstack
        Output "Downloading Saltstack ${SaltVersion}"
        Invoke-WebRequest -Uri https://repo.saltstack.com/windows/Salt-Minion-${SaltVersion}-Py3-AMD64-Setup.exe -OutFile "${Apps}\saltstack.exe"

        # Create salt directory
        New-Item -ItemType Directory -Force -Path "${SaltstackDir}" | Out-Null

        # Extract saltstack in the salt directory
        7zipExtract -source "${Apps}\saltstack.exe" -target "${SaltstackDir}"

        # syncing saltstack with my custom git repo
        Output "Syncing saltstack with custom patches"
        Set-Location ${SaltstackDir}\bin\Lib\site-packages\salt-*
        Rename-Item -Path salt -NewName salt.orig
        & git init .
        & git config core.sparsecheckout true
        Add-Content -Path ".git/info/sparse-checkout" -Value "salt/*"
        Add-Content -Path ".gitignore" -Value "*"
        Add-Content -Path ".gitignore" -Value "!salt"
        & git remote add origin https://github.com/gigi206/salt.git
        if (${env:VSCode_Anywhere_CI}) {
            & git pull --quiet --depth=100 origin vsc${SaltVersion}
            & git checkout --quiet vsc${SaltVersion}
        }
        else {
            & git pull --depth=100 origin vsc${SaltVersion}
            & git checkout vsc${SaltVersion}
        }
        & git branch -d master

        Output "Configuring Saltstack"
        Copy-Item "${SaltstackDir}\conf" -Destination "${SaltstackConfDir}" -Recurse
        # Add ${SaltstackDir} to the PATH
        $OldPath = (Get-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name Path).Path
        # Set PATH
        if (!((${OldPath}).split(';').Contains(${SaltstackDir}))) {
            Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH -Value ("${SaltstackDir};" + "${OldPath};")
        }
        ReloadPathEnv
        # Create minion.d configuration directory
        New-Item -ItemType Directory -Force -Path "${SaltstackConfDirMinion}" | Out-Null
        # Create srv\pillar configuration directory
        New-Item -ItemType Directory -Force -Path "${SaltstackPillarDir}" | Out-Null
        # Create states configuration directory
        New-Item -ItemType Directory -Force -Path "${SaltstackRootsDir}" | Out-Null

        # Download Saltstack configuration
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/conf/minion.d/VSCode-Anywhere.conf -OutFile "${SaltstackConfDirMinion}\VSCode-Anywhere.conf"
        # Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/conf/minion.d/VSCode-Anywhere-offline.conf -OutFile "${SaltstackConfDirMinion}\VSCode-Anywhere-offline.conf"
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/srv/pillar/top.sls -OutFile "${SaltstackPillarDir}\top.sls"
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/srv/pillar/vscode-anywhere.sls -OutFile "${SaltstackPillarDir}\vscode-anywhere.sls"
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/${Gitenv}/salt/conf/srv/pillar/saltstack.sls -OutFile "${SaltstackPillarDir}\saltstack.sls"

        # Impossible to pass extension_modules with salt-call (avoid to create C:\salt dir)
        Add-Content -Path "${SaltstackConfDirMinion}\VSCode-Anywhere.conf" -Value "root_dir: ${SaltstackDir}"

        # Test Saltstack working properly
        if ((& salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" --out=json test.ping | ConvertFrom-Json).local -ne $true) {
            OutputErrror "Saltstack seems not properly installed"
        }
    }
    catch {
        OutputErrror "failed to install Saltstack : $_"
    }
}

function InstallVSCodeAnywhere {
    Header "VSCode-Anywhere"
    Output "Installing Satlstack grains"
    # Set Saltstack grains
    Output "Installing grains => vscode-anywhere:profile"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:profile' "${Profile}"
    Output "Installing grains => vscode-anywhere:path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:path' "${InstallDir}"
    Output "Installing grains => vscode-anywhere:apps:path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:apps:path' "${Apps}"
    Output "Installing grains => vscode-anywhere:tools:path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:tools:path' "${InstallDir}\tools"
    Output "Installing grains => vscode-anywhere:tools:env"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:tools:env' "${InstallDir}\tools\env.ps1"
    Output "Installing grains => vscode-anywhere:config:path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:config:path' "${ConfDir}"
    Output "Installing grains => vscode-anywhere:saltstack:path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:saltstack:path' "${SaltstackDir}"
    Output "Installing grains => vscode-anywhere:saltstack:config_path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:saltstack:config_path' "${SaltstackConfDir}"
    Output "Installing grains => vscode-anywhere:saltstack:minion_path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:saltstack:minion_path' "${SaltstackConfDirMinion}"
    Output "Installing grains => vscode-anywhere:saltstack:roots_path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:saltstack:roots_path' "${SaltstackRootsDir}"
    Output "Installing grains => vscode-anywhere:saltstack:pillar_path"
    & salt-call --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" grains.set 'vscode-anywhere:saltstack:pillar_path' "${SaltstackPillarDir}"

    Output "Installing VSCode-Anywhere"
    & salt-call.bat --config-dir="${SaltstackConfDir}" --file-root="${SaltstackRootsDir}" --pillar-root="${SaltstackPillarDir}" --cachedir="${SaltstackDir}\var\cache\salt\minion" --log-file="${SaltstackDir}\var\log\salt\minion" --id="VSCode-Anywhere" --state-verbose=False state.apply saltenv=${Gitenv} sync_mods=all
}

# function BackupEnv {
#     Header "Environment"
#     Output "Backuping environment"
#     reg export HKCU\Environment ${env:TMP}\VSCode-Anywhere.reg -y
# }

# function RestoreEnv {
#     Header "Environment"
#     Output "Restoring environment"
#     reg import ${env:TMP}\VSCode-Anywhere.reg
# }

Set-ExecutionPolicy Undefined -Scope Process -Force
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
# $Apps = Join-Path -Path "$InstallDir" -ChildPath "Apps"
$Apps = "${InstallDir}\apps"
$SaltstackDir = "${Apps}\saltstack"
$ConfDir = "${InstallDir}\conf"
$SaltstackConfDir = "${ConfDir}\saltstack\conf"
$SaltstackConfDirMinion = "${SaltstackConfDir}\minion.d"
$SaltstackPillarDir = "${ConfDir}\saltstack\pillar"
$SaltstackRootsDir = "${ConfDir}\saltstack\states"

Init
# BackupEnv
InstallScoop
Install7zip
InstallGit
InstallSaltstack
InstallVSCodeAnywhere
# RestoreEnv

############
#   INFO   #
############
#
# Author : Ghislain LE MEUR
# URL    : https://github.com/gigi206/VSCode-Anywhere


##############
#   Params   #
##############
Param(
    [string]$path="$null",
    [string]$conf="$null",
    [switch]$update,
    [switch]$fonts,
    [switch]$link
)


############
#   FUNC   #
############

# Output actions to console
function Output([string]$msg, [bool]$newline=$true, [string]$fgcolor='Cyan', [bool]$star=$true) {
    if ($star) { Write-Host "* " -nonewline -ForegroundColor Green }
    if ($newline) { Write-Host "$msg" -ForegroundColor $fgcolor }
    else { Write-Host -nonewline "$msg" -ForegroundColor $fgcolor }
}

# Output errors to console
function OutputErrror([string]$msg, [bool]$newline=$true, [bool]$exit=$true, [int]$exit_code=1) {
    if ($newline) { Write-Host "Error : $msg" }
    else { Write-Host -nonewline "Error : $msg"n }
    if ($exit) {
        Pause
        exit $exit_code
    }
}

# Output header
function InstallAppHeader([string]$AppName) {
    Write-Host ""                                                               -ForegroundColor Green
    Write-Host "/=============================================================" -ForegroundColor Green
    Write-Host "|"                                                              -ForegroundColor Green
    Write-Host "| $AppName"                                                     -ForegroundColor Green
    Write-Host "|"                                                              -ForegroundColor Green
    Write-Host "\=============================================================" -ForegroundColor Green
    Write-Host ""                                                               -ForegroundColor Green
}

# First function called (create dirs, configure proxy, source env, ...)
function Init  {
    # Init config env
    MSYS2Env
    VSCEnv

    # Change security settings
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Set Proxy settings
    if ($config.base.proxy.url) {
        # Define proxy url
        $proxyUrl = new-object System.Uri($config.base.proxy.url)

        # Define proxy
        [System.Net.WebRequest]::DefaultWebProxy = new-object System.Net.WebProxy ($proxyUrl, $true)

        # Define Proxy credentials
        if ($config.base.proxy.login) {
            #[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
            $proxyCred = New-Object System.Management.Automation.PSCredential($config.base.proxy.login, $config.base.proxy.password)
            [System.Net.WebRequest]::DefaultWebProxy.Credentials = $proxycred
        }
    }

    # Rename previous log file to logfile.old
    if (Test-Path -Path "$log") {
        if (Test-Path -Path "${log}.old") { Remove-Item -Path "${log}.old" }
        Rename-Item -Force -Path "$log" -NewName "${log}.old"
    }

    # Create $ToolsDir directory if doesn't exist
    If (!(Test-Path "$ToolsDir")) {
      New-Item -ItemType Directory -Force -Path "$ToolsDir" | Out-Null
    }

    # Create $FontsDir directory if doesn't exist
    If (!(Test-Path "$FontsDir")) {
        New-Item -ItemType Directory -Force -Path "$FontsDir" | Out-Null
    }

    # Create log directory if doesn't exist
    If (!(Test-Path "$LogDir")) {
        New-Item -ItemType Directory -Force -Path "$LogDir" | Out-Null
    }

    # Create Conf directory if doesn't exist
    If (!(Test-Path "$ConfDir")) {
        New-Item -ItemType Directory -Force -Path "$ConfDir" | Out-Null
    }

    # Copy install and config files to $ToolsDir
    if ("$PSScriptRoot" -ne "$ToolsDir") {
        Copy-Item "$PSCommandPath" -Destination "${ToolsDir}\install.ps1" -Force
        Copy-Item "$ProgramConfig" -Destination "${ConfDir}\${ProgramName}.conf" -Force
    }
}

# Test Internet connection
function TestInternet {
    $internet = Test-Connection -computer google.com -count 2 -quiet
    If (!($internet)) {
        OutputErrror "your computer is not connected to Internet"
    }
}

# Install VSCode
function InstallVSCode {
    InstallAppHeader "Installing $VSCAppName"

    # Skip install if VSCode is already installed
    if (Test-Path -Path "${VSCAppPath_install}\Code.exe") {
        Output "$VSCAppName already installed (skipped). If you want to reinstall delete $VSCAppPath_install directory"
        return
    }

    # Install git for consult last tag version from github
    InstallMSYS2Pkg @('git')

    # Define last tag version for download VSCode
    Set-Location "${MSYS2AppPath_install}\usr\bin"
    $VSCSha = ./env.exe CHERE_INVOKING=1 /usr/bin/bash --login -c "git ls-remote --tags https://github.com/Microsoft/vscode.git | egrep 'refs/tags/[0-9]+\.[0-9]+\.[0-9]+$' | sort -t '/' -k 3 -V | tail -1 | cut -f1"
    $VSCTag = ./env.exe CHERE_INVOKING=1 /usr/bin/bash --login -c "git ls-remote --tags https://github.com/Microsoft/vscode.git | egrep 'refs/tags/[0-9]+\.[0-9]+\.[0-9]+$' | sort -t '/' -k 3 -V | tail -1 | cut -f3 -d'/'"
    $VSCUrl = "https://az764295.vo.msecnd.net/stable/${VSCSha}/VSCode-win32-x64-${VSCTag}.zip"

    # Create install directories
    Output "Create $VSCAppPath_install, $VSCAppPath_extensions and $VSCAppPath_user_data directories"
    New-Item -ItemType Directory -Force -Path "$VSCAppPath_install", "$VSCAppPath_extensions", "$VSCAppPath_user_data" | Out-Null

    Output "Downloading $VSCAppName $VSCTag ($VSCSha)"
    try {
        # Download VSCode zip file
        if ($config.base.vsc_url) { Invoke-WebRequest -Uri $config.base.vsc_url -OutFile "$VSCAppPath\${VSCAppName}.zip" }
        else { Invoke-WebRequest -Uri $VSCUrl -OutFile "$VSCAppPath\${VSCAppName}.zip" }
    }
    catch {
        OutputErrror "failed to download $VSCAppName : $_"
    }

    # Extract VSCode zip file to install dir
    Output "Extracting $VSCAppPath\${VSCAppName}.zip to $VSCAppPath_install"
    Expand-Archive -Path "$VSCAppPath\${VSCAppName}.zip" -DestinationPath "$VSCAppPath_install"

    # Remove VSCode zip file
    Output "Removing $VSCAppPath\${VSCAppName}.zip"
    Remove-Item -Path "$VSCAppPath\${VSCAppName}.zip"

    Output "$VSCAppName is sucessfully installed"
}

# Install 7zip
function Install7zip {
    InstallAppHeader "Installing $7zAppName"

    # Skip install if 7-zip is already installed
    if (Test-Path -Path "$7zAppPath_bin") {
        Output "$7zAppName already installed (skipped). If you want to reinstall delete $7zAppPath_install directory"
        return
    }

    # Download 7-zip archive
    Output "Downloading $7zAppName"
    New-Item -ItemType Directory -Force -Path "$7zAppPath_install" | Out-Null
    try {
        Invoke-WebRequest -Uri $config.base.zip_url -OutFile "${7zAppPath_install}\${7zAppName}.zip"
    }
    catch {
        OutputErrror "failed to download $7zAppName : $_"
    }

    # Extract 7-zip to install dir
    Output "Installing $7zAppName in progress..."
    Expand-Archive -Path "${7zAppPath_install}\${7zAppName}.zip" -DestinationPath "$7zAppPath_install"

    # Remove download file
    Output "Removing $7zAppName tmp files"
    Remove-Item -Recurse -Path "${7zAppPath_install}\${7zAppName}.zip"

    Update7zip

    Output "$7zAppName is sucessfully installed"
}

# Install MSYS2
function InstallMSYS2 {
    # Check if install device is a NTFS filesystem
    if ((Get-Volume -FilePath "$InstallDir").FileSystem -ne 'NTFS') {
        OutputErrror "Install Path $InstallDir must be installed on a NTFS filesystem !"
    }

    # Needed for extract archive tar.xz
    Install7zip

    InstallAppHeader "Installing $MSYS2AppName"

    # Skip install if MSYS2 is already installed
    if (Test-Path -Path "$MSYS2AppPath_install") {
        Output "$MSYS2AppName already installed (skipped). If you want to reinstall delete $MSYS2AppPath_install directory"
        return
    }

    # Create MSYS2 directory
    Output "Create $MSYS2AppPath directory"
    New-Item -ItemType Directory -Force -Path "$MSYS2AppPath" | Out-Null

    # Download MSYS2 archive file
    try {
        if ($config.base.MSYS2_url) {
            Output "Downloading $MSYS2AppName (specific version in config file)"
            Invoke-WebRequest -Uri $config.base.MSYS2_url -OutFile "${MSYS2AppPath}\${MSYS2AppName}.tar.xz"
        }
        else {
            # Define last version for download MSYS2
            $MSYS2Url = Invoke-WebRequest -Uri http://repo.msys2.org/distrib/x86_64/
            $MSYS2Url = $MSYS2Url.Links.href | Select-String -Pattern "^msys2-base-x86_64-[0-9]{8}.tar.xz$" | Sort-Object
            $MSYS2Version = $MSYS2Url[-1]
            $MSYS2Url = "http://repo.msys2.org/distrib/x86_64/$MSYS2Version"

            Output "Downloading latest version $MSYS2AppName ($MSYS2Version)"
            Invoke-WebRequest -Uri $MSYS2Url -OutFile "${MSYS2AppPath}\${MSYS2AppName}.tar.xz"
        }
    }
    catch {
        OutputErrror "failed to download $MSYS2AppName : $_"
    }

    # Extract archive
    Output "Extracting archive $MSYS2AppName"
    7zipExtract "${MSYS2AppPath}\${MSYS2AppName}.tar.xz" "$MSYS2AppPath"
    7zipExtract "${MSYS2AppPath}\${MSYS2AppName}.tar" "$MSYS2AppPath"
    Move-Item -Force -Path "${MSYS2AppPath}\msys64" -Destination "$MSYS2AppPath_install"

    # Change home directory
    Output "Change home directory to /home/${ProgramName}"
    if (Get-Content "${MSYS2AppPath_install}\etc\nsswitch.conf" | Select-String "^ *db_home *:.*") {
        (Get-Content "${MSYS2AppPath_install}\etc\nsswitch.conf") | ForEach-Object { $_ -replace '^ *db_home *:.*', "db_home:  /home/${ProgramName}" } | Set-Content "${MSYS2AppPath_install}\etc\nsswitch.conf"
    }
    else {
        Add-Content -Path "${MSYS2AppPath_install}\etc\nsswitch.conf" -Value "db_home:  /home/${ProgramName}"
    }

    # Need to login for init MSYS2 env
    Output "Initializing $MSYS2AppName" | Tee-Object -a "`"$log`""
    Start-Process -Wait -FilePath "${MSYS2AppPath_install}\msys2_shell.cmd" -ArgumentList "''" | Tee-Object -a "`"$log`""

    # Upgrade MSYS2
    Output -fgcolor Red "╔══════════════════════════════════════════════════════════════════════════════════════════════════╗"
    Output -fgcolor Red "║ Upgrade OS : for continue installation please close the window after the update is completed !!! ║"
    Output -fgcolor Red "╚══════════════════════════════════════════════════════════════════════════════════════════════════╝"
    $update_cmd = 'yes y | LC_ALL=C pacman -Syu'
    MSYS2Cmd @("$update_cmd", "$update_cmd; kill -9 -1")

    Output "$MSYS2AppName is sucessfully installed"
}

# Install zeal if enabled
function InstallZeal {
    InstallAppHeader "Installing $ZealAppName"

    InstallVSCPkg @('deerawan.vscode-dash')

    # Skip install if Zeal is already installed
    if (Test-Path -Path "$ZealAppPath_install") {
        Output "$ZealAppName already installed (skipped). If you want to reinstall delete $ZealAppPath_install directory"
        return
    }

    # Create $ZealAppPath if doesn't exist
    If (!(Test-Path "$ZealAppPath_install")) {
        New-Item -ItemType Directory -Force -Path "$ZealAppPath" | Out-Null
    }

    # Download Zeal archive file
    if ($config.base.zeal_enabled) {
        try {
            if ($config.base.zeal_url) {
                Output "Downloading $ZealAppName (specific version in config file)"
                Invoke-WebRequest -Uri $config.base.zeal_url -OutFile "${ZealAppPath}\${ZealAppName}.zip"
            }
            else {
                # Define last version for download Zeal
                $ZealUrl = Invoke-WebRequest -Uri https://dl.bintray.com/zealdocs/windows/
                $ZealUrl = $ZealUrl.Links.href | Select-String -Pattern "^zeal-portable-.*-windows-x86.zip$" | Sort-Object
                $ZealVersion = $ZealUrl[-1]
                $ZealUrl = "https://dl.bintray.com/zealdocs/windows/$ZealVersion"

                Output "Downloading latest $ZealAppName version ($ZealVersion)"
                Invoke-WebRequest -Uri "$ZealUrl" -OutFile "${ZealAppPath}\${ZealAppName}.zip"
            }
        }
        catch {
            OutputErrror "failed to download $ZealAppName : $_"
        }

        Output "Installing $ZealAppName"

        # Extract Zeal
        Expand-Archive -Path "${ZealAppPath}\${ZealAppName}.zip" -DestinationPath "$ZealAppPath"

        # Remove downloading file archive
        Remove-Item -Recurse -Path "${ZealAppPath}\${ZealAppName}.zip"

        # Move extracted files to $ZealAppPath_install
        Move-Item -Force -Path "${ZealAppPath}\zeal-portable*" -Destination "$ZealAppPath_install"

        # Install C runtime libraries dependancies
        foreach ($dll in 'vcruntime140.dll', 'msvcp140.dll'){
            if (!(Test-Path -Path ((New-Object -ComObject Shell.Application).Namespace(0x29).Self.Path + "$dll")) -and !(Test-Path -Path "${ZealAppPath_install}\$dll")) {
                Output "Installing dll => ${ZealAppPath_install}\$dll"
                Invoke-WebRequest -Uri "https://github.com/gigi206/VSCode-Anywhere/raw/master/Windows/dll/$dll" -OutFile "${ZealAppPath_install}\$dll"
            }
        }

        # Set downloaded Zeal version in version file
        "$ZealVersion".split('-')[2] > "${ZealAppPath_install}\version"

        Output "$ZealAppName is sucessfully installed"
    }
}

# Install MSYS2 pkgs
function InstallMSYS2Pkg([string[]]$pkg) {
    $pkg = $pkg -join ' '
    Output "Installing MSYS2 packages : $pkg"
    MSYS2Cmd @("pacman --noconfirm --force --needed -Sy $pkg")
}

# Install VSCode plugins
function InstallVSCPkg([string[]]$pkgs) {
    foreach ($pkg in $pkgs) {
        output "Installing VSCode extension : $pkg" | Tee-Object -a "`"$log`""
        Start-Process -Wait -FilePath "${VSCAppPath_install}\bin\Code.cmd" -ArgumentList "--user-data-dir `"$VSCAppPath_user_data`" --extensions-dir `"$VSCAppPath_extensions`" --install-extension $pkg" | Tee-Object -a "`"$log`""
    }
}

# Install docsets for Zeal
function InstallZealPkg([string[]]$pkgs) {
    # Install docsets only if Zeal is enabled
    if ($config.base.zeal_enabled) {
        # Skip install if Zeal is already installed
        if (!(Test-Path -Path "$ZealAppPath_docsets")) {
            New-Item -ItemType Directory -Force -Path "$ZealAppPath_docsets" | Out-Null
        }

        if (Test-Path -Path "${ZealAppPath}\tmp") {
            Remove-Item -Force -Recurse "${ZealAppPath}\tmp"
        }

        Add-Type -Assembly System.Drawing

        foreach ($pkg in $pkgs) {
            if (Test-Path -Path "${ZealAppPath_docsets}\${pkg}.docset") {
                Output "Zeal docsets $pkg is already installed (skipped)"
                continue
            }

            Output "Installing Zeal docset $pkg"

            # Request zeal api
            $pkg_api = (Invoke-WebRequest -Uri "http://api.zealdocs.org/v1/docsets" | ConvertFrom-Json) | Where-Object { $_.name -eq "$pkg" }

            if($pkg_api) {
                New-Item -ItemType Directory -Force -Path "${ZealAppPath}\tmp" | Out-Null
                $tmp_file1 = "${ZealAppPath}\tmp\${pkg}.tgz"
                $tmp_file2 = "${ZealAppPath}\tmp\${pkg}.tar"

                # Download dash docsets
                try {
                    [xml]$xml = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Kapeli/feeds/master/${pkg}.xml"
                    $pkg_url = $xml.GetElementsByTagName('url')[0].'#text'

                    #Output "Downloading Zeal $name to $tmp_file1"
                    Invoke-WebRequest -Uri $pkg_url -OutFile "$tmp_file1"
                }
                catch {
                    OutputErrror "failed to download docset for $pkg => $pkg_url : $_"
                }

                # Extract zip file
                #Output "Extracting $tmp_file1"
                7zipExtract -source "$tmp_file1" -target "${ZealAppPath}\tmp"
                7zipExtract -source "$tmp_file2" -target "${ZealAppPath}\tmp"
                Move-Item -Force -Path "${ZealAppPath}\tmp\*" -Destination "${ZealAppPath_docsets}\${pkg}.docset"
                Remove-Item -Force -Recurse "${ZealAppPath}\tmp"

                # Generate icons
                $imageBytes = [Convert]::FromBase64String($pkg_api.icon)
                $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                $ms.Write($imageBytes, 0, $imageBytes.Length)
                $image = [System.Drawing.Image]::FromStream($ms, $true)
                $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon.png")

                $imageBytes = [Convert]::FromBase64String($pkg_api.icon2x)
                $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                $ms.Write($imageBytes, 0, $imageBytes.Length)
                $image = [System.Drawing.Image]::FromStream($ms, $true)
                $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon@2x.png")

                # Generate meta.json file
                if ($pkg_api.versions) { $pkg_api | Add-Member -NotePropertyName version -NotePropertyValue $pkg_api.versions[0] }
                $pkg_api.PSObject.Properties.Remove('sourceId')
                $pkg_api.PSObject.Properties.Remove('versions')
                $pkg_api.PSObject.Properties.Remove('icon2x')
                $pkg_api.PSObject.Properties.Remove('icon')
                $pkg_api.PSObject.Properties.Remove('id')
                $pkg_api | ConvertTo-Json | Out-File -Encoding utf8 "${ZealAppPath_docsets}\${pkg}.docset\meta.json"
            }
            else {
                # Request zeal api
                $pkg_api = (Invoke-WebRequest -Uri "http://london.kapeli.com/feeds/zzz/user_contributed/build/index.json" | ConvertFrom-Json).docsets."$pkg"

                if (! $pkg_api) {
                    OutputErrror "$pkg not found ! => $pkg_api"
                }

                New-Item -ItemType Directory -Force -Path "${ZealAppPath}\tmp" | Out-Null
                $tmp_file1 = "${ZealAppPath}\tmp\${pkg}.tgz"
                $tmp_file2 = "${ZealAppPath}\tmp\${pkg}.tar"

                # Download dash docsets
                try {
                    $pkg_url = "http://sanfrancisco.kapeli.com/feeds/zzz/user_contributed/build/${pkg}/${pkg}.tgz"
                    #Output "Downloading Zeal $name to $tmp_file1"
                    Invoke-WebRequest -Uri $pkg_url -OutFile "$tmp_file1"
                }
                catch {
                    OutputErrror "failed to download docset for $pkg => $pkg_url : $_"
                }

                # Extract zip file
                #Output "Extracting $tmp_file1"
                7zipExtract -source "$tmp_file1" -target "${ZealAppPath}\tmp"
                7zipExtract -source "$tmp_file2" -target "${ZealAppPath}\tmp"
                Move-Item -Force -Path "${ZealAppPath}\tmp\*" -Destination "${ZealAppPath_docsets}\${pkg}.docset"
                Remove-Item -Force -Recurse "${ZealAppPath}\tmp"

                # Generate icon
                if ($pkg_api.icon) {
                    $imageBytes = [Convert]::FromBase64String($pkg_api.icon)
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length)
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon.png")
                }

                # Generate icon@2x
                if ($pkg_api.'icon@2x') {
                    $imageBytes = [Convert]::FromBase64String($pkg_api.'icon@2x')
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length)
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon@2x.png")
                }

                # Generate meta.json file
                if ($pkg_api.name) {
                    $pkg_api | Add-Member -NotePropertyName title -NotePropertyValue $pkg_api.name
                    $pkg_api.name = "$pkg"
                }
                $pkg_api.PSObject.Properties.Remove('author')
                $pkg_api.PSObject.Properties.Remove('archive')
                $pkg_api.PSObject.Properties.Remove('icon')
                $pkg_api.PSObject.Properties.Remove('icon@2x')
                $pkg_api.PSObject.Properties.Remove('aliases')
                $pkg_api.PSObject.Properties.Remove('specific_versions')
                $pkg_api | ConvertTo-Json | Out-File -Encoding utf8 "${ZealAppPath_docsets}\${pkg}.docset\meta.json"
            }
        }
    }
}

# Extract with 7-zip
function 7zipExtract ([string]$source, [string]$target, [string]$delete=$true) {
    Output "Extracting $source => $target"
    Start-Process -Wait -WorkingDirectory "$target" -FilePath "$7zAppPath_bin" -ArgumentList "x `"$source`" -y"

    # Delete archive if delete=$true
    if ($delete) { Remove-Item -Path "$source" }
}

# Set VSCode settings
function SetVSCSettings([object]$conf) {
    # Define VSCode settings file
    $settings_path = "$VSCAppPath_user_data\User\settings.json"

    # Create settings file if doesn't exist
    if (!(Test-Path "$settings_path" -PathType Leaf)) {
        '{}' | Out-File -Encoding utf8 "$settings_path"
    }

    # Load current settings
    try {
        $settings = Get-Content "$settings_path" -Raw | ConvertFrom-Json
    }
    catch {
        OutputErrror "mistake in config file $settings_path : $_"
    }

    # Apply config to current settings
    foreach ($key in $conf.psobject.properties.name) {
        # Load config settings
        $val = $conf."$key"
        if ($val -is [string]) { $val = $ExecutionContext.InvokeCommand.ExpandString($val) }
        output "Set VSCode configuration : $key => $val"

        # Add config settings
        $settings | Add-Member @{$key=$val} -PassThru -Force | Out-Null
    }

    # Write new settings file
    $settings | ConvertTo-Json | Out-File -Encoding utf8 "$settings_path"
}

# Set keyboard settings
function SetVSCKeyboard([object[]]$conf) {
    # Define VSCode keyboard key bindings file
    $keybindings_path = "$VSCAppPath_user_data\User\keybindings.json"

    # Create keyboard key bindings file if doesn't exist
    if (!(Test-Path "$keybindings_path" -PathType Leaf)) {
        '[]' | Out-File -Encoding utf8 "$keybindings_path"
    }

    # Load current key bindings file
    try {
        $keyboard = Get-Content "$keybindings_path" -Raw | ConvertFrom-Json
    }
    catch {
        OutputErrror "mistake in configuration file $keybindings_path : $_"
    }

    $file = @()

    foreach ($key in $conf) {
        output "Set VSCode keyboard :", ($key | ConvertTo-Json -Compress)

        # If user config not present in config file then add user config
        if (!($keyboard | Where-Object{ $_.key -eq $key.key })) {
            $myobject = New-Object PSCustomObject
            $myobject | Add-Member -type NoteProperty -name key -Value $key.key
            if ($key.command) { $myobject | Add-Member -type NoteProperty -name command -Value $key.command }
            if ($key.when) { $myobject | Add-Member -type NoteProperty -name when -Value $key.when }
            $file += $myobject
        }
    }

    foreach ($line in $keyboard) {
        $match = $false

        foreach ($key in $conf) {
            # Modify line if exists in user config and config file
            if ($line.key -eq $key.key) {
                $match = $true
                $myobject = New-Object PSCustomObject
                $myobject | Add-Member -type NoteProperty -name key -Value $key.key
                if ($key.command) { $myobject | Add-Member -type NoteProperty -name command -Value $key.command }
                if ($key.when) { $myobject | Add-Member -type NoteProperty -name when -Value $key.when }
                $file += $myobject
            }
        }

        # If not found in user config keep in config file
        if (!($match)) {
            $myobject = New-Object PSCustomObject
            $myobject | Add-Member -type NoteProperty -name key -Value $line.key
            if ($line.command) { $myobject | Add-Member -type NoteProperty -name command -Value $line.command }
            if ($line.when) { $myobject | Add-Member -type NoteProperty -name when -Value $line.when }
            $file += $myobject
        }
    }

    # Write new key bindings file
    #$file | ConvertTo-Json | Out-File -Encoding utf8 "$keybindings_path"
    $json = $file | ConvertTo-Json
    if ($json -match '^\[') {
        $json | Out-File -Encoding utf8 "$keybindings_path"
    }
    else {
        "[`n" + $json + "`n]" | Out-File -Encoding utf8 "$keybindings_path"
    }
}

# Run MSYS2 command
function MSYS2Cmd([string[]]$cmds, [string]$shell="$MSYS2AppPath_install\usr\bin\mintty.exe", [string]$shell_args="-t $ProgramName /usr/bin/env CHERE_INVOKING=1 /usr/bin/bash --login -c", [bool]$wait=$true) {
    foreach ($cmd in $cmds) {
        Output "RUN MSYS2 command : $cmd"

        # Define env before RUN command
        $env:MSYS2_PATH_TYPE = 'inherit'
        foreach ($key in $MSYS2Env.keys) {
            #if ($key -eq 'path') { [Environment]::SetEnvironmentVariable("$key", $MSYS2Env.$key + $env:Path) }
            #else { [Environment]::SetEnvironmentVariable("$key", $MSYS2Env.$key) }
            [Environment]::SetEnvironmentVariable("$key", $MSYS2Env.$key)
        }

        # Write command to logfile
        "`n`n>>> $cmd <<<" | Out-File -Force -Append -Encoding utf8 "$log"

        # Run command (no translation variable here). If you need to translate vars, prefer run cmd
        if ($wait) { Start-Process -Wait -FilePath "$shell" -ArgumentList "$shell_args '($cmd) 2>&1 | tee -a `"$log`"'" }
        else { Start-Process -Wait -FilePath "$shell" -ArgumentList "$shell_args '($cmd) 2>&1 | tee -a `"$log`"'" }
    }
}

# Run Powershell command
function Cmd([string[]]$cmds) {
    foreach ($cmd in $cmds) {
        $cmd = $ExecutionContext.InvokeCommand.ExpandString($cmd)
        Output "RUN command : $cmd"

        # Define env before RUN command
        $env:Path = $MSYS2Env.path + $env:Path
        foreach ($key in $MSYS2Env.keys) {
            #if ($key -eq 'path') { [Environment]::SetEnvironmentVariable("$key", $MSYS2Env.$key + $env:Path) }
            #else { [Environment]::SetEnvironmentVariable("$key", $MSYS2Env.$key) }
            [Environment]::SetEnvironmentVariable("$key", $MSYS2Env.$key)
        }

        # Write command to logfile
        "`n`n>>> $cmd <<<" | Out-File -Force -Append -Encoding utf8 "$log"

        # Run command with variables translated
        Invoke-Expression $cmd | Out-File -Force -Append -Encoding utf8 "$log"
    }
}

# Define MSYS2 env
function MSYS2Env {
    # Define config msys2_env to $myenv
    $myenv = @{}
    foreach ($item in $config.extensions.psobject.properties.name) {
        if ($config.extensions.$item.enabled -eq $true) {
            foreach ($envName in $config.extensions.$item.msys2_env.psobject.properties.name) {
                # If var env name is the path env then add to $mypath
                if ($envName -eq 'path') {
                    $mypath += $ExecutionContext.InvokeCommand.ExpandString($config.extensions.$item.msys2_env.$envName)
                }
                # Else add to $myenv immediatly
                else {
                    $myenv.Add("$envName", $ExecutionContext.InvokeCommand.ExpandString($config.extensions.$item.msys2_env.$envname))
                }
            }
        }
    }

    # Add final path $mypath to $myenv
    $myenv.Add("path", "$mypath")

    # Export $myenv to $MSYS2Env (global var)
    Set-Variable -Name MSYS2Env -Value ($myenv) -Scope Global
}

# Define VSCode env
function VSCEnv {
    # Define config vsc_env to $myenv
    $myenv = @{}
    foreach ($item in $config.extensions.psobject.properties.name) {
        if ($config.extensions.$item.enabled -eq $true) {
            foreach ($envName in $config.extensions.$item.vsc_env.psobject.properties.name) {
                # If var env name is the path env then add to $mypath
                if ($envName -eq 'path') {
                    $mypath += $ExecutionContext.InvokeCommand.ExpandString($config.extensions.$item.vsc_env.$envName)
                }
                # Else add to $myenv immediatly
                else {
                    $myenv.Add("$envName", $ExecutionContext.InvokeCommand.ExpandString($config.extensions.$item.vsc_env.$envname))
                }
            }
        }
    }

    # Add final path $mypath to $myenv
    $myenv.Add("path", "$mypath")

    # Export $myenv to $VSCEnv (global var)
    Set-Variable -Name VSCEnv -Value ($myenv) -Scope Global
}

# Install all references from config file
function InstallConfig {
    # For all settings extensions from config file
    foreach ($item in $config.extensions.psobject.properties.name) {
        # Define settings only if extension is enabled
        if ($config.extensions.$item.enabled -eq $true) {
            InstallAppHeader "Installing $item in progress"

            # Call Cmd function if cmd_pre is defined
            if ($config.extensions.$item.cmd_pre.Length -gt 0) { Cmd $config.extensions.$item.cmd_pre }

            # Call MSYS2Cmd function if msys2_cmd_pre is defined
            if ($config.extensions.$item.msys2_cmd_pre.Length -gt 0) { MSYS2Cmd $config.extensions.$item.msys2_cmd_pre }

            # Call InstallMSYS2Pkg function if msys2_pkg is defined
            if ($config.extensions.$item.msys2_pkg.Length -gt 0) { InstallMSYS2Pkg $config.extensions.$item.msys2_pkg }

            # Call SetVSCSettings function if vsc_settings is defined
            if ($config.extensions.$item.vsc_pkg.Length -gt 0) { InstallVSCPkg $config.extensions.$item.vsc_pkg }

            # Call SetVSCSettings function if vsc_settings is defined
            if ($config.extensions.$item.vsc_settings.psobject.properties.name.Length -gt 0) { SetVSCSettings $config.extensions.$item.vsc_settings }

            # Call SetVSCKeyboard function if vsc_keyboard is defined
            if ($config.extensions.$item.vsc_keyboard.psobject.properties.name.Length -gt 0) { SetVSCKeyboard $config.extensions.$item.vsc_keyboard }

            # Call InstallZealPkg function if zeal_pkg is defined
            if ($config.extensions.$item.zeal_pkg.Length -gt 0) { InstallZealPkg $config.extensions.$item.zeal_pkg }

            # Call MSYS2Cmd function if msys2_cmd_post is defined
            if ($config.extensions.$item.msys2_cmd_post.Length -gt 0) { MSYS2Cmd $config.extensions.$item.msys2_cmd_post }

            # Call Cmd function if cmd_post is defined
            if ($config.extensions.$item.cmd_post.Length -gt 0) { Cmd $config.extensions.$item.cmd_post }
        }
    }
}

# Create shortcut
function Shortcut([string[]]$source, [string[]]$target, [string[]]$arguments, [string[]]$description=$null, [string[]]$cwd=$null,[string[]]$icon=$null) {
    $shortcut=(New-Object -ComObject WScript.Shell).CreateShortcut("${target}.lnk")
    $shortcut.TargetPath = "$source"
    if ($arguments) { $shortcut.Arguments = "$arguments" }
    if ($description) { $shortcut.Description = "$description" }
    if ($cwd) { $shortcut.WorkingDirectory = "$cwd" }
    if ($icon) { $shortcut.IconLocation = "$icon" }
    $shortcut.Save()
}

# Create start script for run VScode
function MakeScriptVSC {
    # Define location
    $ScriptFile = "${ToolsDir}\VSCode.cmd"

    Output "Make VSC script file $ScriptFile"

    # Remove it if exists
    If (Test-Path "$ScriptFile") { Remove-Item -Path "$ScriptFile" }

    # Write code to script
    "@echo off" | Out-File -Encoding ascii -Append "$ScriptFile"
    "setlocal" | Out-File -Encoding ascii -Append "$ScriptFile"

    foreach ($key in $VSCEnv.keys) {
        if ($key -eq 'path') { "set $key=" + $VSCEnv.$key + '%PATH%' -replace [regex]::escape("$InstallDir" + '\'), '%~dp0..\' | Out-File -Encoding ascii -Append "$ScriptFile" }
        else { "set $key=" + $VSCEnv.$key -replace [regex]::escape("$InstallDir" + '\'), '%~dp0..\' | Out-File -Encoding ascii -Append "$ScriptFile" }
    }

    "set VSCODE_DEV=" | Out-File -Encoding ascii -Append "$ScriptFile"
    "set ELECTRON_RUN_AS_NODE=1" | Out-File -Encoding ascii -Append "$ScriptFile"
    "call `"%~dp0..\VSCode\install\Code.exe`" `"%~dp0..\VSCode\install\resources\app\out\cli.js`" --user-data-dir `"%~dp0..\VSCode\user-data`" --extensions-dir `"%~dp0..\VSCode\extensions`" %*"  | Out-File -Encoding ascii -Append "$ScriptFile"
    "endlocal" | Out-File -Encoding ascii -Append "$ScriptFile"

    # Create shortcut
    $icon = "${VSCAppPath_install}\Code.exe,0"
    Shortcut -source "$ScriptFile" -target "${InstallDir}\$ProgramName" -cwd "$InstallDir" -description "Start $VSCAppName" -icon "$icon"
}

# Create start script for run MSYS2 console
function MakeScriptMSYS2 {
    # Define location
    $ScriptFile = "${ToolsDir}\MSYS2.cmd"
    $opts = $config.base.MSYS2_opts -join ' -o '
    $opts = '-o ' + "$opts"

    Output "Make MSYS2 script file $ScriptFile"

    # Remove it if exists
    If (Test-Path "$ScriptFile") { Remove-Item -Path "$ScriptFile" }

    # Write code to script
    "@echo off" | Out-File -Encoding ascii -Append "$ScriptFile"
    "setlocal" | Out-File -Encoding ascii -Append "$ScriptFile"
    "set MSYS2_PATH_TYPE=inherit" | Out-File -Encoding ascii -Append "$ScriptFile"

    foreach ($key in $MSYS2Env.keys) {
        if ($key -eq 'path') { "set $key=" + $MSYS2Env.$key + '%PATH%' -replace [regex]::escape("$InstallDir" + '\'), '%~dp0..\' | Out-File -Encoding ascii -Append "$ScriptFile" }
        else { "set $key=" + $MSYS2Env.$key -replace [regex]::escape("$InstallDir" + '\'), '%~dp0..\' | Out-File -Encoding ascii -Append "$ScriptFile" }
    }

    'call ' + '"' + "${MSYS2AppPath_install}\usr\bin\mintty.exe" + '"' + " -t $ProgramName $opts" + ' - %*' -replace [regex]::escape("$InstallDir" + '\'), '%~dp0..\' | Out-File -Encoding ascii -Append "$ScriptFile"
    "endlocal" | Out-File -Encoding ascii -Append "$ScriptFile"

    # Create shortcut
    $icon = "${MSYS2AppPath_install}\msys2.exe,0"
    Shortcut -source "$ScriptFile" -target "${InstallDir}\Terminal" -cwd "$InstallDir" -description "Start $MSYS2AppName" -icon "$icon"
}

# Create script for Zeal
function MakeScriptZeal {
    if ($config.base.zeal_enabled) {
        Output "Update registry for $ZealAppName"

        # Add dash-plugin to registy (for plugin dash)
        #if (!(Test-Path "HKCU:\Software\Classes\dash-plugin")) { New-Item "HKCU:\Software\Classes\dash-plugin" -force -ea SilentlyContinue  | Out-Null }
        #if (!(Test-Path "HKCU:\Software\Classes\dash-plugin\DefaultIcon")) { New-Item "HKCU:\Software\Classes\dash-plugin\DefaultIcon" -force -ea SilentlyContinue  | Out-Null }
        #if (!(Test-Path "HKCU:\Software\Classes\dash-plugin\shell")) { New-Item "HKCU:\Software\Classes\dash-plugin\shell" -force -ea SilentlyContinue  | Out-Null }
        #if (!(Test-Path "HKCU:\Software\Classes\dash-plugin\shell\open")) { New-Item "HKCU:\Software\Classes\dash-plugin\shell\open" -force -ea SilentlyContinue  | Out-Null }
        #if (!(Test-Path "HKCU:\Software\Classes\dash-plugin\shell\open\command")) { New-Item "HKCU:\Software\Classes\dash-plugin\shell\open\command" -force -ea SilentlyContinue  | Out-Null }
        #New-ItemProperty -Path 'HKCU:\Software\Classes\dash-plugin' -Name '(default)' -Value "Dash Plugin Protocol" -PropertyType String -Force -ea SilentlyContinue  | Out-Null
        #New-ItemProperty -Path 'HKCU:\Software\Classes\dash-plugin' -Name 'URL Protocol' -Value "" -PropertyType String -Force -ea SilentlyContinue | Out-Null
        #New-ItemProperty -Path 'HKCU:\Software\Classes\dash-plugin\DefaultIcon' -Name '(default)' -Value "${ZealAppPath_bin},1" -PropertyType String -Force -ea SilentlyContinue | Out-Null
        #New-ItemProperty -Path 'HKCU:\Software\Classes\dash-plugin\shell\open\command' -Name '(default)' -Value "$ZealAppPath_bin %1" -PropertyType String -Force -ea SilentlyContinue | Out-Null
        &"$ZealAppPath_bin" --register

        Output "Update zeal.ini file"

        # Update zeal.ini file
        if (Test-Path -Path "${ZealAppPath_install}\zeal.ini") {
            Get-Content "${ZealAppPath_install}\zeal.ini" | Foreach-Object { $_ -replace '^path=.*docsets$', "path=$ZealAppPath_docsets" } > "${ZealAppPath_install}\zeal.ini"
        }

        Output "Make install script file ${InstallDir}\Documentation"

        $source = "${ZealAppPath_bin}"
        $icon = "${ZealAppPath_bin},0"
        Shortcut -source "$source" -target "${InstallDir}\Documentation" -cwd "$ZealAppPath_install" -description "Documentation $ZealAppName" -icon "$icon"
    }
}

# Create script for new install
function MakeScriptInstall {
    Output "Make install script file ${ToolsDir}\Install"

    $source = "${ToolsDir}\" + (Get-Item $PSCommandPath).Name
    $arguments = '-NoProfile -InputFormat None -ExecutionPolicy Bypass -File "' + "$source" + '" -conf "' + "${ConfDir}\${ProgramName}.conf" + '"'
    $icon = ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + '\SHELL32.dll,13')
    Shortcut -source ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + "\WindowsPowerShell\v1.0\powershell.exe") -target "${ToolsDir}\Install" -cwd "$ToolsDir" -arguments "$arguments" -description "Install $ProgramName" -icon "$icon"
}

# Create script for updates
function MakeScriptUpdate {
    Output "Make update script file $ToolsDir\Update"

    $source = "${ToolsDir}\" + (Get-Item $PSCommandPath).Name
    $arguments = '-NoProfile -InputFormat None -ExecutionPolicy Bypass -File "' + "$source" + '" -conf "' + "${ConfDir}\${ProgramName}.conf" + '" -update'
    $icon = ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + '\SHELL32.dll,46')
    Shortcut -source ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + "\WindowsPowerShell\v1.0\powershell.exe") -target "${ToolsDir}\Update" -cwd "$ToolsDir" -arguments "$arguments" -description "Update $ProgramName" -icon "$icon"
}

# Install fonts
function MakeScriptInstallFonts {
    Output "Make install font script file ${ToolsDir}\InstallFonts"

    $source = "${ToolsDir}\" + (Get-Item $PSCommandPath).Name
    $arguments = '-NoProfile -InputFormat None -ExecutionPolicy Bypass -File "' + "$source" + '" -conf "' + "${ConfDir}\${ProgramName}.conf" + '" -fonts'
    $icon = (New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + '\SHELL32.dll,74'
    Shortcut -source ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + "\WindowsPowerShell\v1.0\powershell.exe") -target "${ToolsDir}\InstallFonts" -cwd "$ToolsDir" -arguments "$arguments" -description "Install fonts for $ProgramName" -icon "$icon"
}

# Link shortcuts to new path
function MakeScriptLink {
    #$source = "${ToolsDir}\" + (Get-Item $PSCommandPath).Name
    #$arguments = '-NoProfile -InputFormat None -ExecutionPolicy Bypass -File "' + $source + '" -link'
    #$icon = ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + '\SHELL32.dll,146')
    #Shortcut -source ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + "\WindowsPowerShell\v1.0\powershell.exe") -target "${ToolsDir}\Link" -cwd "$ToolsDir" -arguments "$arguments" -description "Link $ProgramName shortcuts" -icon "$icon"

    # Define location
    $ScriptFile = "${ToolsDir}\Link.cmd"

    Output "Make link script file $ScriptFile"

    # Remove it if exists
    If (Test-Path "$ScriptFile") { Remove-Item -Path "$ScriptFile" }

    # For all settings extensions from config file
    foreach ($item in $config.extensions.psobject.properties.name) {
        # Define settings only if extension is enabled
        if ($config.extensions.$item.enabled -eq $true) {
            InstallAppHeader "Link $item in progress"

            # Call SetVSCSettings function if vsc_settings is defined
            if ($config.extensions.$item.vsc_settings.psobject.properties.name.Length -gt 0) { SetVSCSettings $config.extensions.$item.vsc_settings }
        }
    }

    # Write code to script
    "@echo off" | Out-File -Encoding ascii -Append "$ScriptFile"
    ((New-Object -ComObject Shell.Application).Namespace(0x25).Self.Path + '\WindowsPowerShell\v1.0\powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -File "' + (Get-Item $PSCommandPath).Name + '" -conf "' + "..\" + (Get-Item $ConfDir).Name + "\" + (Get-Item $ProgramConfig).Name + '" -link') | Out-File -Encoding ascii -Append "$ScriptFile"
}

# Create VSCode / MSYS2 scripts
function MakeScripts {
    InstallAppHeader "Make tools scripts..."
    MakeScriptVSC
    MakeScriptMSYS2
    MakeScriptZeal
    MakeScriptInstall
    MakeScriptUpdate
    MakeScriptInstallFonts
    MakeScriptLink
}

# Update VSCode and Third-Party
function Update {
    Update7zip
    UpdateMSYS2
    UpdateVSCode
    UpdateZeal

    # For all settings extensions from config file
    foreach ($item in $config.extensions.psobject.properties.name) {
        # Define settings only if extension is enabled
        if ($config.extensions.$item.enabled -eq $true) {
            InstallAppHeader "Update $item in progress"

            # Call Cmd function if msys2_cmd_update is defined
            if ($config.extensions.$item.msys2_cmd_update.Length -gt 0) { MSYS2Cmd $config.extensions.$item.msys2_cmd_update }

            # Call Cmd function if cmd_update is defined
            if ($config.extensions.$item.cmd_update.Length -gt 0) { Cmd $config.extensions.$item.cmd_update }

            # Call UpdateZealPkg function if zeal-pkg is defined
            if ($config.extensions.$item.zeal_pkg.Length -gt 0) { UpdateZealPkg $config.extensions.$item.zeal_pkg }
        }
    }
}

# Update MSYS2
function UpdateMSYS2 {
    InstallAppHeader "Update $MSYS2AppName"

    $update_cmd = 'yes y | LC_ALL=C pacman -Syu; kill -9 -1'
    MSYS2Cmd @("$update_cmd", "$update_cmd")
}

# Update VSCode
function UpdateVSCode {
    InstallAppHeader "Update $VSCAppName"

    # Update VSCode
    if (Test-Path "${VSCAppPath_install}\resources\app\package.json") {
        $VSCPkg = Get-Content "${VSCAppPath_install}\resources\app\package.json" -Raw | ConvertFrom-Json
    $VSCVersion = $VSCPkg.version
    }
    else { $VSCVersion = 'Unknown' }

    # Define last tag version for download VSCode
    Set-Location "${MSYS2AppPath_install}\usr\bin"
    $VSCSha = ./env.exe CHERE_INVOKING=1 /usr/bin/bash --login -c "git ls-remote --tags https://github.com/Microsoft/vscode.git | egrep 'refs/tags/[0-9]+\.[0-9]+\.[0-9]+$' | sort -t '/' -k 3 -V | tail -1 | cut -f1"
    $VSCTag = ./env.exe CHERE_INVOKING=1 /usr/bin/bash --login -c "git ls-remote --tags https://github.com/Microsoft/vscode.git | egrep 'refs/tags/[0-9]+\.[0-9]+\.[0-9]+$' | sort -t '/' -k 3 -V | tail -1 | cut -f3 -d'/'"
    $VSCUrl = "https://az764295.vo.msecnd.net/stable/${VSCSha}/VSCode-win32-x64-${VSCTag}.zip"

    # Install new version of VSCode
    if ($VSCVersion -ne $VSCTag) {
        # Remove previous version
        Output "Remove previous VSCode version $VSCVersion"
        try {
            if (Test-Path "$VSCAppPath_install") { Remove-Item -Recurse -Force "$VSCAppPath_install" }
        }
        catch {
            OutputErrror "failed to remove $VSCAppPath_install ! VSCode is in use ? : $_"
        }

        # Create install directories
        Output "Create $VSCAppPath_install directory"
        New-Item -ItemType Directory -Force -Path "$VSCAppPath_install" | Out-Null

        Output "Downloading $VSCAppName $VSCTag ($VSCSha)"
        try {
            # Download VSCode zip file
            Invoke-WebRequest -Uri $VSCUrl -OutFile "$VSCAppPath\${VSCAppName}.zip"
        }
        catch {
            OutputErrror "failed to download $VSCAppName : $_"
        }

        # Extract VSCode zip file to install dir
        Output "Extracting $VSCAppPath\${VSCAppName}.zip to $VSCAppPath_install"
        Expand-Archive -Path "$VSCAppPath\${VSCAppName}.zip" -DestinationPath "$VSCAppPath_install"

        # Remove VSCode zip file
        Output "Removing $VSCAppPath\${VSCAppName}.zip"
        Remove-Item -Path "$VSCAppPath\${VSCAppName}.zip"

        Output "$VSCAppName is sucessfully upgraded from version $VSCVersion to $VSCTag"
    }
    else {
        Output "VSCode is already to the latest version $VSCVersion"
    }
}

#  Update 7-zip
function Update7zip {
    InstallAppHeader "Update $7zAppName"
    $url= 'https://www.7-zip.org'
    $current_version_url = 'a/7z' + (&$7zAppPath_bin)[1].Split()[2].Replace('.', '') + '-extra.7z'
    $last_version_url = ((Invoke-WebRequest -Uri "${url}/download.html").Links.href -match '^a/7z[0-9]+-extra.7z')[0]

    if ("$current_version_url" -ne "$last_version_url") {
        New-Item -ItemType Directory -Force -Path "${7zAppPath}\tmp" | Out-Null
        Invoke-WebRequest -Uri "${url}/$last_version_url" -OutFile "${7zAppPath}\tmp\${7zAppName}.7z"
        7zipExtract -source "${7zAppPath}\tmp\${7zAppName}.7z" -target "${7zAppPath}\tmp"
        Remove-Item "$7zAppPath_install" -Force -Recurse
        Move-Item -Path "${7zAppPath}\tmp" -Destination "$7zAppPath_install"
    }
}

# Update Zeal
function UpdateZeal {
    InstallAppHeader "Update $ZealAppName"

    # Test if version exist
    If (Test-Path "${ZealAppPath_install}\version") {
        $version = Get-Content -Path "${ZealAppPath_install}\version"
    }

    # Download Zeal archive file
    if ($config.base.zeal_enabled) {
        try {
            # Define last version for download Zeal
            $ZealUrl = Invoke-WebRequest -Uri https://dl.bintray.com/zealdocs/windows/
            $ZealUrl = $ZealUrl.Links.href | Select-String -Pattern "^zeal-portable-.*-windows-x86.zip$" | Sort-Object
            $ZealVersion = $ZealUrl[-1]
            $ZealUrl = "https://dl.bintray.com/zealdocs/windows/$ZealVersion"

            if ("$version" -eq "$ZealVersion".split('-')[2]) {
                Output "$ZealAppName is already to the last version $version (skipped)"
                return
            }

            Output "Downloading latest version $ZealAppName ($ZealVersion)"
            Invoke-WebRequest -Uri "$ZealUrl" -OutFile "${ZealAppPath}\${ZealAppName}.zip"
        }
        catch {
            OutputErrror "failed to download $ZealAppName : $_"
        }

        Output ("Upgrading $ZealAppName from version $version to " + "$ZealVersion".split('-')[2])

        # Extract Zeal archive
        Expand-Archive -Path "${ZealAppPath}\${ZealAppName}.zip" -DestinationPath "$ZealAppPath"

        # Move extracted files to $ZealAppPath_install
        Get-ChildItem "${ZealAppPath_install}" -Recurse | Where-Object { $_.FullName -notlike "*\" + (Get-Item "$ZealAppPath_docsets").BaseName + "\*" } | Remove-Item -Recurse -Exclude (Get-Item "$ZealAppPath_docsets").BaseName
        Move-Item -Force -Path "${ZealAppPath}\zeal-portable*\*" -Destination "$ZealAppPath_install"

        # Remove downloading file archive
        Remove-Item -Recurse -Path "${ZealAppPath}\${ZealAppName}.zip", "${ZealAppPath}\zeal-portable*"

        # Install C runtime libraries dependancies
        foreach ($dll in 'vcruntime140.dll', 'msvcp140.dll'){
            if (!(Test-Path -Path ((New-Object -ComObject Shell.Application).Namespace(0x29).Self.Path + "$dll")) -and !(Test-Path -Path "${ZealAppPath_install}\$dll")) {
                Output "Installing dll => ${ZealAppPath_install}\$dll"
                Invoke-WebRequest -Uri "https://github.com/gigi206/VSCode-Anywhere/raw/master/Windows/dll/$dll" -OutFile "${ZealAppPath_install}\$dll"
            }
        }

        # Set the Zeal version
        "$ZealVersion".split('-')[2] > "${ZealAppPath_install}\version"

        Output "$ZealAppName is sucessfully updated"
    }
}

# Update Zeal docsets
function UpdateZealPkg([string[]]$pkgs) {
    # Update docsets only if Zeal is enabled
    if ($config.base.zeal_enabled) {
        # Skip install if Zeal is already installed
        if (!(Test-Path -Path "$ZealAppPath_docsets")) {
            New-Item -ItemType Directory -Force -Path "$ZealAppPath_docsets" | Out-Null
        }

        if (Test-Path -Path "${ZealAppPath}\tmp") {
            Remove-Item -Force -Recurse "${ZealAppPath}\tmp"
        }

        Add-Type -Assembly System.Drawing

        foreach ($pkg in $pkgs) {
            # Request zeal api
            $pkg_api = (Invoke-WebRequest -Uri "http://api.zealdocs.org/v1/docsets" | ConvertFrom-Json) | Where-Object { $_.name -eq "$pkg" }

            if($pkg_api) {
                # Current version of the docset
                if ((Get-Content "${ZealAppPath_docsets}\${pkg}.docset\meta.json" | ConvertFrom-Json).version) { $version_installed = (Get-Content "${ZealAppPath_docsets}\${pkg}.docset\meta.json" | ConvertFrom-Json).version + '-' + (Get-Content "${ZealAppPath_docsets}\${pkg}.docset\meta.json" | ConvertFrom-Json).revision }
                else { $version_installed = (Get-Content "${ZealAppPath_docsets}\${pkg}.docset\meta.json" | ConvertFrom-Json).revision }

                # Last version of the docset
                if ($pkg_api.versions -and $pkg_api.versions[0]) { $version_api = $pkg_api.versions[0] + '-' + $pkg_api.revision }
                else { $version_api = $pkg_api.revision }

                if ("$version_api" -ne "$version_installed") {
                    Output "Updating Zeal docset $pkg from version $version_installed to $version_api"

                    New-Item -ItemType Directory -Force -Path "${ZealAppPath}\tmp" | Out-Null
                    $tmp_file1 = "${ZealAppPath}\tmp\${pkg}.tgz"
                    $tmp_file2 = "${ZealAppPath}\tmp\${pkg}.tar"

                    # Download dash docsets
                    try {
                        [xml]$xml = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Kapeli/feeds/master/${pkg}.xml"
                        $pkg_url = $xml.GetElementsByTagName('url')[0].'#text'

                        #Output "Downloading Zeal $name to $tmp_file1"
                        Invoke-WebRequest -Uri $pkg_url -OutFile "$tmp_file1"
                    }
                    catch {
                        OutputErrror "failed to download docset for $pkg => $pkg_url : $_"
                    }

                    # Extract zip file
                    #Output "Extracting $tmp_file1"
                    7zipExtract -source "$tmp_file1" -target "${ZealAppPath}\tmp"
                    7zipExtract -source "$tmp_file2" -target "${ZealAppPath}\tmp"
                    Remove-Item -Force -Recurse "${ZealAppPath_docsets}\${pkg}.docset"
                    Move-Item -Force -Path "${ZealAppPath}\tmp\*" -Destination "${ZealAppPath_docsets}\${pkg}.docset"
                    Remove-Item -Force -Recurse "${ZealAppPath}\tmp"

                # Generate icon
                if ($pkg_api.icon) {
                    $imageBytes = [Convert]::FromBase64String($pkg_api.icon)
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length)
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon.png")
                }

                # Generate icon@2x
                if ($pkg_api.'icon@2x') {
                    $imageBytes = [Convert]::FromBase64String($pkg_api.'icon@2x')
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length)
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon@2x.png")
                }

                    # Generate meta.json file
                    if ($pkg_api.versions) { $pkg_api | Add-Member -NotePropertyName version -NotePropertyValue $pkg_api.versions[0] }
                    $pkg_api.PSObject.Properties.Remove('sourceId')
                    $pkg_api.PSObject.Properties.Remove('versions')
                    $pkg_api.PSObject.Properties.Remove('icon2x')
                    $pkg_api.PSObject.Properties.Remove('icon')
                    $pkg_api.PSObject.Properties.Remove('id')
                    $pkg_api | ConvertTo-Json | Out-File -Encoding utf8 "${ZealAppPath_docsets}\${pkg}.docset\meta.json"
                }
                else {
                    Output "Zeal docset $pkg is already to the last version $version_installed"
                }
            }
            else {
               # Request zeal api
               $pkg_api = (Invoke-WebRequest -Uri "http://london.kapeli.com/feeds/zzz/user_contributed/build/index.json" | ConvertFrom-Json).docsets."$pkg"

                if (! $pkg_api) {
                    OutputErrror "$pkg not found !"
                }

                # Current version of the docset
                $version_installed = (Get-Content "${ZealAppPath_docsets}\${pkg}.docset\meta.json" | ConvertFrom-Json).version

                # Last version of the docset
                $version_api = $pkg_api.version

                if ("$version_api" -ne "$version_installed") {
                    Output "Updating Zeal docset $pkg from version $version_installed to $version_api"

                    New-Item -ItemType Directory -Force -Path "${ZealAppPath}\tmp" | Out-Null
                    $tmp_file1 = "${ZealAppPath}\tmp\${pkg}.tgz"
                    $tmp_file2 = "${ZealAppPath}\tmp\${pkg}.tar"

                    # Download dash docsets
                    try {
                        $pkg_url = "http://sanfrancisco.kapeli.com/feeds/zzz/user_contributed/build/${pkg}/${pkg}.tgz"

                        #Output "Downloading Zeal $name to $tmp_file1"
                        Invoke-WebRequest -Uri $pkg_url -OutFile "$tmp_file1"
                    }
                    catch {
                        OutputErrror "failed to download docset for $pkg => $pkg_url : $_"
                    }

                    # Extract zip file
                    #Output "Extracting $tmp_file1"
                    7zipExtract -source "$tmp_file1" -target "${ZealAppPath}\tmp"
                    7zipExtract -source "$tmp_file2" -target "${ZealAppPath}\tmp"
                    Remove-Item -Force -Recurse "${ZealAppPath_docsets}\${pkg}.docset"
                    Move-Item -Force -Path "${ZealAppPath}\tmp\*" -Destination "${ZealAppPath_docsets}\${pkg}.docset"
                    Remove-Item -Force -Recurse "${ZealAppPath}\tmp"

                    # Generate icons
                    $imageBytes = [Convert]::FromBase64String($pkg_api.icon)
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length)
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon.png")

                    $imageBytes = [Convert]::FromBase64String($pkg_api.'icon@2x')
                    $ms = New-Object IO.MemoryStream($imageBytes, 0, $imageBytes.Length)
                    $ms.Write($imageBytes, 0, $imageBytes.Length)
                    $image = [System.Drawing.Image]::FromStream($ms, $true)
                    $image.Save("${ZealAppPath_docsets}\${pkg}.docset\icon@2x.png")

                    # Generate meta.json file
                    if ($pkg_api.name) {
                        $pkg_api | Add-Member -NotePropertyName title -NotePropertyValue $pkg_api.name
                        $pkg_api.name = "$pkg"
                    }
                    $pkg_api.PSObject.Properties.Remove('author')
                    $pkg_api.PSObject.Properties.Remove('archive')
                    $pkg_api.PSObject.Properties.Remove('icon')
                    $pkg_api.PSObject.Properties.Remove('icon@2x')
                    $pkg_api.PSObject.Properties.Remove('aliases')
                    $pkg_api.PSObject.Properties.Remove('specific_versions')
                    $pkg_api | ConvertTo-Json | Out-File -Encoding utf8 "${ZealAppPath_docsets}\${pkg}.docset\meta.json"
                }
                else {
                    Output "Zeal docset $pkg is already to the last version $version_installed"
                }
            }
        }
    }
}

# Install all ttf files present in $FontsDir
function InstallFonts {
    InstallAppHeader "Installing fonts"

    foreach ($font in Get-ChildItem -Recurse -Path "$FontsDir" -Include "*.ttf") {
        Output "Installing $font"
        (New-Object -ComObject Shell.Application).Namespace(0x14).CopyHere($font.fullname, 0x10)
    }
}

# Installation is finished
function Finish {
    InstallAppHeader "Congratulations, installation is finished !!!"
    Pause
}


############
#   VARS   #
############
$ProgramName = "VSCode-Anywhere"

if (!($conf)) { $ProgramConfig = Join-Path -Path "$PSScriptRoot" -ChildPath "${ProgramName}.conf" }
else { $ProgramConfig = $conf }

if ("$path") { $InstallDir = Join-Path -Path "$path" -ChildPath "$ProgramName" }
else {
    if ((Get-Item -Path "$PSScriptRoot").Parent.Name -eq "$ProgramName") { $InstallDir = (Get-Item -Path "$PSScriptRoot").Parent.FullName }
    else { $InstallDir = Join-Path -Path "$PSScriptRoot" -ChildPath "$ProgramName" }
}

$LogDir = Join-Path -Path "$InstallDir" -ChildPath "Logs"
$log = Join-Path -Path "$LogDir" -ChildPath "install.log"
if ($update) { $log = Join-Path -Path "$LogDir" -ChildPath "update.log" }
if ($fonts) { $log = Join-Path -Path "$LogDir" -ChildPath "fonts.log" }
if ($link) { $log = Join-Path -Path "$LogDir" -ChildPath "link.log" }
$ThirdParty = Join-Path -Path "$InstallDir" -ChildPath "Third-Party"
$FontsDir = Join-Path -Path "$ThirdParty" -ChildPath "Fonts"
$ToolsDir = Join-Path -Path "$InstallDir" -ChildPath "Tools"
$ConfDir = Join-Path -Path "$InstallDir" -ChildPath "Conf"

try {
    InstallAppHeader "Loading config"
    Output "Parsing config file $ProgramConfig"
    if (!(Test-Path -Path "$ProgramConfig")) { OutputErrror "configuration file $ProgramConfig doesn't exist !" }
    $config = Get-Content "$ProgramConfig" -Raw | ConvertFrom-Json
}
catch {
    OutputErrror "mistake in configuration file $ProgramConfig : $_"
}

# VSCode
$VSCAppName = "VSCode"
$VSCAppPath = Join-Path -Path "$InstallDir" -ChildPath "$VSCAppName"
$VSCAppPath_install = Join-Path -Path "$VSCAppPath" -ChildPath "install"
$VSCAppPath_extensions = Join-Path -Path "$VSCAppPath" -ChildPath "extensions"
$VSCAppPath_user_data = Join-Path -Path "$VSCAppPath" -ChildPath "user-data"

# MSYS2
$MSYS2AppName = "MSYS2"
$MSYS2AppPath = Join-Path -Path "$ThirdParty" -ChildPath "$MSYS2AppName"
$MSYS2AppPath_install = Join-Path -Path "$MSYS2AppPath" -ChildPath "install"

# 7zip
$7zAppName = '7-zip'
$7zAppPath = Join-Path -Path "$ThirdParty" -ChildPath "$7zAppName"
$7zAppPath_install = Join-Path -Path "$7zAppPath" -ChildPath "install"
$7zAppPath_bin = Join-Path -Path "$7zAppPath_install" -ChildPath "7za.exe"

# Zeal
$ZealAppName = "Zeal"
$ZealAppPath = Join-Path -Path "$ThirdParty" -ChildPath "$ZealAppName"
$ZealAppPath_install = Join-Path -Path "$ZealAppPath" -ChildPath "install"
$ZealAppPath_bin = Join-Path -Path "$ZealAppPath_install" -ChildPath "zeal.exe"
$ZealAppPath_docsets = Join-Path -Path "$ZealAppPath_install" -ChildPath "docsets"


############
#   CODE   #
############

Init

if ($update) {
    TestInternet
    Update
}
elseif ($fonts) {
    InstallFonts
}
elseif ($link) {
    MakeScripts
}
else {
    TestInternet
    InstallMSYS2
    InstallVSCode
    InstallZeal
    InstallConfig
    MakeScripts
}

Finish

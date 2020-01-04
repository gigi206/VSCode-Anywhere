##########
Quickstart
##########

Windows
#######

Open a powershell console and enter the following command:

.. code-block:: powershell

    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.ps1 -OutFile $env:TMP\VSCode-Anywhere.ps1; & $env:TMP\VSCode-Anywhere.ps1 -Gitenv V2

..    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/salt/VSCode-Anywhere.ps1'))

Now you can click on ``VSCode-Anywhere`` in the :file:`C:\\VSCode-Anywhere`
directory.

For more information, please read the full
`Windows documentation <Windows/index.html>`_ for more details.

Linux
#####

In development.

MacOS
#####

In the future.

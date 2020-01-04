.. _windows_installation:

#######
Windows
#######

Installation
############

VSCode-Anywhere has been tested only with Windows 10 but it supposed to work
also with recent Windows version.

To install VSCode-Anywhere on Windows, you need have to have PowerShell
installed.

Example:

.. code-block:: powershell

    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.ps1 -OutFile $env:TMP\VSCode-Anywhere.ps1; & $env:TMP\VSCode-Anywhere.ps1 -InstallDir <InstallDir> -Profile windows_user

Options
*******

Installation options are:

- **Gitenv** *(optional)*: git branch to use for installation
  (**master** by default)
- **InstallDir** *(optional)*: installation directory
  (:file:`C:\\VSCode-Anywhere` by default)
- **SaltVersion** *(optional)*: Saltstack version to use
  (value evolves with time). It is not recommended to change this value
  (only for testing purposes for developers).
- **Profile** *(optional)*: type of installation profile
  (**windows_user** by default)

.. _profile_windows:

There are 3 kinds on ``profile`` for different use cases :

- **windows_admin**: require administrator rights (for local use)
- **windows_user**: no administrator rights required (for local use)
- **windows_portable**: no administrator rights required
  (for use with a portable device like an usb stick)


+------------------+----------------------------+-----------------------------+
| profile          | advantages                 | disadvantages               |
+==================+============================+=============================+
| windows_admin    | - Few modules need         | - Some applications will be |
|                  |   administrator rights for |   installed on the system   |
|                  |   a better compatibility   |   (outside the installation |
|                  |   (see documentation of    |   folder ``InstallDir``)    |
|                  |   each module)             | - Not recommended to run on |
|                  | - Good performance         |   another computer with     |
|                  |                            |   portable device like usb  |
|                  |                            |   stick (``tools/link.ps1`` |
|                  |                            |   may have a high chance    |
|                  |                            |   to install some missing   |
|                  |                            |   components)               |
|                  |                            | - Add only a few            |
|                  |                            |   possibilities, just some  |
|                  |                            |   modules uses it (see the  |
|                  |                            |   module documentation for  |
|                  |                            |   know if it is a           |
|                  |                            |   requirement)              |
+------------------+----------------------------+-----------------------------+
| windows_user     | - No administrator rights  | - Not recommended to run on |
|                  |   needed for the           |   another computer with     |
|                  |   installation process and |   portable device like usb  |
|                  |   modules                  |   stick (``tools/link.ps1`` |
|                  | - Good performance         |   may have a low chance to  |
|                  |                            |   install some missing      |
|                  |                            |   components)               |
+------------------+----------------------------+-----------------------------+
| windows_portable | - Can be installed on a    | - Could have performance    |
|                  |   portable device like an  |   issue and more            |
|                  |   usb stick                |   possibility to encounter  |
|                  |                            |   bugs                      |
+------------------+----------------------------+-----------------------------+

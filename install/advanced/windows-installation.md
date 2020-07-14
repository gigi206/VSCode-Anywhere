# Windows installation

## Installation

VSCode-Anywhere has been tested only with Windows 10 but it supposed to work also with the recent Windows version.

To install VSCode-Anywhere on Windows, you need have to have PowerShell installed.

Installation example:

{% tabs %}
{% tab title="Powershell" %}
```text
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-WebRequest -Uri https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.ps1 -OutFile $env:TMP\VSCode-Anywhere.ps1; & $env:TMP\VSCode-Anywhere.ps1 -InstallDir <InstallDir> -Profile windows_user
```
{% endtab %}
{% endtabs %}

### Options

Installation options are:

* **Gitenv** _\(optional\)_: git branch to use for installation \(**V2** by default\)
* **InstallDir** _\(optional\)_: installation directory \(`C:\VSCode-Anywhere` by default\)
* **SaltVersion** _\(optional\)_: Saltstack version to use \(value evolves with time\). It is not recommended to change this value \(only for testing purposes for developers\).
* **Profile** _\(optional\)_: type of installation profile \(**windows\_user** by default\)
* **saltopts** _\(optional\)_: Salt options

#### Profiles

There are 3 kinds of `profile` \(see **Profile** option\) for different use cases :

* **windows\_admin**: require administrator rights \(for local use\)
* **windows\_user**: no administrator rights required \(for local use\)
* **windows\_portable**: no administrator rights required \(for use with a portable device like an USB stick\)

<table>
  <thead>
    <tr>
      <th style="text-align:left"><b>profile</b>
      </th>
      <th style="text-align:left"><b>advantages</b>
      </th>
      <th style="text-align:left"><b>disadvantages</b>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left"><b>windows_admin</b>
      </td>
      <td style="text-align:left">
        <ul>
          <li>Few modules need administrator rights for better compatibility (see the
            documentation of each module)</li>
          <li>Good performance</li>
        </ul>
      </td>
      <td style="text-align:left">
        <ul>
          <li>Some applications will be installed on the system (outside the installation
            folder <code>InstallDir</code>)</li>
          <li>Not recommended to run on another computer with a portable device like
            a USB stick (<code>tools/link.ps1</code> may have a high chance to install
            some missing components)</li>
          <li>Add only a few possibilities, just some modules uses it (see the module
            documentation for know if it is a requirement)</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>windows_user</b>
      </td>
      <td style="text-align:left">
        <ul>
          <li>No administrator rights needed for the installation process and modules</li>
          <li>Good performance</li>
        </ul>
      </td>
      <td style="text-align:left">
        <ul>
          <li>Not recommended to run on another computer with a portable device like
            a USB stick (<code>tools/link.ps1</code> may have a low chance to install
            some missing components)</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>windows_portable</b>
      </td>
      <td style="text-align:left">
        <ul>
          <li>Can be installed on a portable device like a USB stick</li>
        </ul>
      </td>
      <td style="text-align:left">
        <ul>
          <li>Could have performance issue and more possibility to encounter bugs</li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>


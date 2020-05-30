# Linux installation

## Installation

VSCode-Anywhere has been tested with several Linux distributions but it is impossible to test with all.

If you have any problems, please open an [issue](https://github.com/gigi206/VSCode-Anywhere/issues).

Installation example:

```text
$ bash <(curl -sL https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.sh) --help
usage :
  -h | --help        : print this help
  -e | --gitenv      : git branch (default: master)
  -d | --installdir  : installation directory (default: ~/VSCode-Anywhere)
  -v | --saltversion : saltstack version to use
  -p | --profile     : VSCode-Anywhere profile to use (default: linux_user)
  -s | --saltopts    : Salt options
$ bash <(curl -sL https://raw.githubusercontent.com/gigi206/VSCode-Anywhere/V2/VSCode-Anywhere.sh) --installdir <install_dir>
```

{% hint style="info" %}
Replace `<install_dir>` by your installation path.
{% endhint %}

### Options

Installation options are:

* **gitenv** _\(optional\)_: git branch to use for installation \(**V2** by default\)
* **installdir** _\(optional\)_: installation directory \(`~/VSCode-Anywhere` by default\)
* **saltversion** _\(optional\)_: Saltstack version to use \(value evolves with time\). It is not recommended to change this value \(only for testing purposes for developers\).
* **profile** _\(optional\)_: type of installation profile \(**linux\_user** by default\)

#### Profiles

There are 3 kinds of `profile` for different use cases :

* **linux\_admin**: require administrator rights \(for local use\)
* **linux\_user**: no administrator rights required \(for local use\)
* **linux\_portable**: does not exist. Use `linux_user` instead \(also works with a portable device like an usb stick\)

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
      <td style="text-align:left"><b>linux_admin</b>
      </td>
      <td style="text-align:left">
        <ul>
          <li>No Linux namespaces</li>
          <li>Better compatibility</li>
        </ul>
      </td>
      <td style="text-align:left">
        <ul>
          <li><code>/nix</code> and <code>/home/linuxbrew</code> will be created on your
            system</li>
          <li>Not recommended if you already nix or brew is installed on your system</li>
          <li>Need to have a privileged account (sudo)</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>linux_user</b>
      </td>
      <td style="text-align:left">
        <ul>
          <li>No privileged account needed for the installation process and modules</li>
          <li>&#x2018;&#x2019;/nix&#x2019;&#x2019; and <code>/home/linuxbrew</code> is
            encapsulated in the <code>installdir</code> directory with the namespaces</li>
        </ul>
      </td>
      <td style="text-align:left">
        <ul>
          <li>less compatibility</li>
          <li>Must have a Linux distribution that manage namespaces</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>linux_portable</b>
      </td>
      <td style="text-align:left">
        <ul>
          <li>Not needed at this time</li>
        </ul>
      </td>
      <td style="text-align:left">
        <ul>
          <li>Not needed at this time</li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

## Post-installation

### Linux shortcuts icons

For some security reasons, some file manager like the [gnome Files](https://wiki.gnome.org/action/show/Apps/Files) are no longer allow to run desktop files inside the file manager which causes some problems for VSCode-Anywhere.

If you are in this case, there are multiple choices:

* if you are **root**, you can install another file manager that allow to run desktop files like [nemo](https://en.wikipedia.org/wiki/Nemo_%28file_manager%29) and run the desktop files with this manager
* On [gnome](https://www.gnome.org), you can copy desktop fils in the desktop and right click on them and select `Allow Launching`

{% embed url="https://youtu.be/fUvqz2G\_G64" %}

* Copy manually desktop files in `~/.local/share/applications` or set  `install_desktop_files` to `True` in [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) and runthe [install.sh](../../structure/tools/install.md) script:

```yaml
vscode-anywhere:
  config:
    linux:
      install_desktop_files: True
```

### HOME

After the installation with the `linux_user` profile \(default\), the home directory is not longer your home inside VSCode-Anywhere but  it is inside`VSCode-Anywhere/apps/vscode-anywhere/home`.

This mechanism aims to avoid polluting your home directory. If you want to retrieve your real home directory, there are 2 ways:

* remove the `VSCode-Anywhere/apps/vscode-anywhere/home` and create a link that points to your home:

```text
rm -fr VSCode-Anywhere/apps/vscode-anywhere/home
ln -s ~ VSCode-Anywhere/apps/vscode-anywhere/home
```

* override settings in [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls):

```yaml
vscode-anywhere:
    env_core:
        USER: myuser
        HOME: myhome
```

{% hint style="info" %}
Replace `myuser` and `myhome` by your real user and your real home directory.
{% endhint %}


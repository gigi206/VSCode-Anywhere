---
description: Know issues
---

# FAQ

## Installation failed

VSCode-Anywhere actually does not support spaces in the install directory path.

## On Linux .desktop files do not appear correctly

This is a limitation due to your file manager, please read [the available solutions](install/advanced/linux-installation.md#linux-shortcuts-icons).

## On Linux, my $HOME is not my real HOME

Please read [the possible workarounds](install/advanced/linux-installation.md#home).

## Some Saltstack states failing

Simply run again the install or update script. VSCode-Anywhere will compute what is missing on your system.

{% hint style="warning" %}
If the problem persists, you can open an issue.
{% endhint %}

## VSCode-Anywhere is very slow when installing, locks up the CPU, or shows access denied errors

It’s likely that your antivirus or anti-malware program is doing a realtime scan as files are being extracted.

Please see Antivirus and Anti-Malware problems for more information and possible workarounds.

{% hint style="info" %}
It is advised to put the installation directory in the white list of your antivirus or anti-malware program.
{% endhint %}

## VSCode-Anywhere takes a lot of disk space

You can free up disk space with the following command to delete all unnecessary things:

```text
$ cd <install_dir>/tools
$ ./vscode-anywhere.sh vscode_anywhere.cleanup
local:
----------
brew:
    - 1578 store paths deleted, 2633.53 MiB freed
nix:
    - ...
    - ...
    - ...
```

{% hint style="info" %}
Replace `vscode-anywhere.sh` by `vscode-anywhere.ps1` on Windows.
{% endhint %}

## Language is only detected at the 2nd run

VSCode-Anywhere detects the OS locale and sets it automatically inside VSCode.

There is a bug inside VSCode and the language is only detected in the **2nd** run.

VSCode-Anywhere auto-detects and configure for you the following languages: `en`, `fr`, `es`, `de`, `it`, `ja`, `ru`, `hu`, `ko`, `bg`, `tr`, `pt_br`, `zh_cn` and `zh_tw`.

## I have the following message: _found a tab character that violates indentation_

In all files in the conf directory of your root installation, you must use spaces and not tabs.

The best way is to use VSCode-Anywhere to edit your config files because by default it replaces tabs with spaces.

If you get the following messages, please replace all of your tabs by spaces in your configuration files:

```text
[CRITICAL] Rendering SLS 'vscode-anywhere' failed, render error:
found a tab character that violate indentation
Traceback (most recent call last):
File "C:\VSCode-Anywhere\apps\saltstack\bin\lib\site-packages\salt-3000.1-py3.5.egg\salt\renderers\yaml.py", line 65, in render
    data = yamlloader.load(yaml_data, Loader=get_yaml_loader(argline))
File "C:\VSCode-Anywhere\apps\saltstack\bin\lib\site-packages\salt-3000.1-py3.5.egg\salt\utils\yamlloader.py", line 171, in load
    return yaml.load(stream, Loader=Loader)
File "C:\VSCode-Anywhere\apps\saltstack\bin\lib\site-packages\yaml\__init__.py", line 114, in load
    return loader.get_single_data()
File "C:\VSCode-Anywhere\apps\saltstack\bin\lib\site-packages\yaml\constructor.py", line 41, in get_single_data
    node = self.get_single_node()
File "ext\_yaml.pyx", line 707, in _yaml.CParser.get_single_node
File "ext\_yaml.pyx", line 725, in _yaml.CParser._compose_document
File "ext\_yaml.pyx", line 776, in _yaml.CParser._compose_node
File "ext\_yaml.pyx", line 890, in _yaml.CParser._compose_mapping_node
File "ext\_yaml.pyx", line 776, in _yaml.CParser._compose_node
File "ext\_yaml.pyx", line 890, in _yaml.CParser._compose_mapping_node
File "ext\_yaml.pyx", line 776, in _yaml.CParser._compose_node
File "ext\_yaml.pyx", line 890, in _yaml.CParser._compose_mapping_node
File "ext\_yaml.pyx", line 732, in _yaml.CParser._compose_node
File "ext\_yaml.pyx", line 905, in _yaml.CParser._parse_next_event
yaml.scanner.ScannerError: while scanning a plain scalar
in "<unicode string>", line 9, column 14
found a tab character that violate indentation
in "<unicode string>", line 10, column 1

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
File "C:\VSCode-Anywhere\apps\saltstack\bin\lib\site-packages\salt-3000.1-py3.5.egg\salt\pillar\__init__.py", line 745, in render_pstate
    **defaults)
File "C:\VSCode-Anywhere\apps\saltstack\bin\lib\site-packages\salt-3000.1-py3.5.egg\salt\template.py", line 101, in compile_template
    ret = render(input_data, saltenv, sls, **render_kwargs)
File "C:\VSCode-Anywhere\apps\saltstack\bin\lib\site-packages\salt-3000.1-py3.5.egg\salt\renderers\yaml.py", line 69, in render
    raise SaltRenderError(err_type, line_num, exc.problem_mark.buffer)
salt.exceptions.SaltRenderError: found a tab character that violate indentation
[CRITICAL] Pillar render error: Rendering SLS 'vscode-anywhere' failed. Please see master log for details.
local:
    Data failed to compile:
----------
    Pillar failed to render with the following messages:
----------
    Rendering SLS 'vscode-anywhere' failed. Please see master log for details.
```


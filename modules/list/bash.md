# Bash

![](https://upload.wikimedia.org/wikipedia/commons/8/82/Gnu-bash-logo.svg)

## About

[Bash](https://www.gnu.org/software/bash/) is the Bourne Again SHell. Bash is a sh-compatible shell that incorporates useful features from the Korn shell \(ksh\) and C shell \(csh\).

## Installation

Change `enable` from `False` to `True` in the `bash` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    ansible:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere bash module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/bash/defaults.yaml).
{% endhint %}

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### timonwong.shellcheck

This [extension](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck) is a linter for sh / bash.

#### rogalmic.bash-debug

This [extension](https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug) is a bash debugger GUI frontend based on bashdb scripts.

### VSCode settings

#### Windows settings

```javascript
{
    "shellcheck.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\shellcheck\\current\\shellcheck.exe"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "shellcheck.executablePath": "/home/linuxbrew/.linuxbrew/bin/shellcheck"
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### scoop

* [shellcheck](https://github.com/ScoopInstaller/Main/blob/master/bucket/shellcheck.json)

### Linux software

#### brew

* [shellcheck](https://formulae.brew.sh/formula/shellcheck)

### MacOS software

#### brew

* [shellcheck](https://formulae.brew.sh/formula/shellcheck)

## Documentation

* [Ansible](https://github.com/Kapeli/feeds/blob/master/Ansible.xml)
* [Jinja](https://github.com/Kapeli/feeds/blob/master/Jinja.xml)

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

No specific settings.


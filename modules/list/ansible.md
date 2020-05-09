# Ansible

![](https://upload.wikimedia.org/wikipedia/commons/2/24/Ansible_logo.svg)

## About

[Ansible](https://www.ansible.com/) is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.

## Installation

Change `enable` from `False` to `True` in the `ansible` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    ansible:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere ansible module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/ansible/defaults.yaml).
{% endhint %}

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### vscoss.vscode-ansible

This [extension](https://marketplace.visualstudio.com/items?itemName=vscoss.vscode-ansible) is designed to increase developer productivity authoring, testing and using Ansible with Azure. The extension provides cool features around playbook authoring and execution. It supports running playbook from various places e.g. Docker, local installation, remote machines via ssh and Cloud Shell. 

![Code snippets](https://github.com/VSChina/vscode-ansible/raw/master/images/authoring.gif)

![Run Ansible playbook](https://github.com/VSChina/vscode-ansible/raw/master/images/menu.png)

### VSCode settings

No [settings](https://code.visualstudio.com/docs/getstarted/settings).

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

No software.

### Linux software

#### brew

* [ansible](https://formulae.brew.sh/formula/ansible)

### MacOS software

#### brew

* [ansible](https://formulae.brew.sh/formula/ansible)

## Documentation

* [Ansible](https://github.com/Kapeli/feeds/blob/master/Ansible.xml)
* [Jinja](https://github.com/Kapeli/feeds/blob/master/Jinja.xml)

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

No specific settings.


# Perl

![](https://upload.wikimedia.org/wikipedia/commons/1/15/Logo_De_Perl.png)

## About

[Perl](https://www.perl.org/) is a highly capable, feature-rich programming language with over 30 years of development.

## Installation

Change `enable` from `False` to `True` in the `perl` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    perl:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere perl module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/perl/defaults.yaml).
{% endhint %}

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### cfgweb.vscode-perl

This [extension](https://marketplace.visualstudio.com/items?itemName=cfgweb.vscode-perl) aims to bring code intelligence for the Perl language to Visual Studio Code, mainly through the use of Exuberant Ctags.

#### d9705996.perl-toolbox

This [extension](https://marketplace.visualstudio.com/items?itemName=d9705996.perl-toolbox) provides support for linting and syntax checking for Perl.

#### mortenhenriksen.perl-debug

This [extension](https://marketplace.visualstudio.com/items?itemName=mortenhenriksen.perl-debug) provides a debugger for Perl in Visual Studio Code.

![](https://github.com/raix/vscode-perl-debug/raw/master/images/vscode-perl-debugger.gif)

### VSCode settings

#### Windows settings

```javascript
{
    "perl.ctagsPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\ctags\\current\\ctags.exe",
    "perl.perltidy": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\perl\\current\\perl\\bin\\perltidy.bat",
    "perl-toolbox.syntax.path": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\perl\\current\\perl\\bin",
    "perl-toolbox.lint.exec": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\perl\\current\\perl\\site\\bin\\perlcritic.bat"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "perl.ctagsPath": "/home/linuxbrew/.linuxbrew/bin/ctags",
    "perl.perltidy": "/home/linuxbrew/.linuxbrew/bin/perltidy",
    "perl-toolbox.syntax.path": "/home/myuser/VSCode-Anwyhere/apps/vscode-anywhere/home/.nix-profile/bin",
    "perl-toolbox.lint.exec": "/home/myuser/VSCode-Anwyhere/apps/vscode-anywhere/home/.nix-profile/bin/perlcritic"    
}
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

#### MacOS settings

```javascript
{
    "perl.ctagsPath": "/home/linuxbrew/.linuxbrew/bin/ctags",
    "perl.perltidy": "/home/linuxbrew/.linuxbrew/bin/perltidy",
    "perl-toolbox.syntax.path": "/home/myuser/VSCode-Anwyhere/apps/vscode-anywhere/home/.nix-profile/bin",
    "perl-toolbox.lint.exec": "/home/myuser/VSCode-Anwyhere/apps/vscode-anywhere/home/.nix-profile/bin/perlcritic"    
}
```

{% hint style="info" %}
Assuming you have installed in the directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software <a id="software"></a>

### Windows software <a id="windows-software"></a>

#### scoop

* [perl](https://github.com/ScoopInstaller/Main/blob/master/bucket/perl.json)
* [ctags](https://github.com/ScoopInstaller/Main/blob/master/bucket/ctags.json)

### Linux software <a id="linux-software"></a>

#### brew <a id="brew"></a>

* ​[make](https://formulae.brew.sh/formula/make)
* [gcc](https://formulae.brew.sh/formula/gcc)
* [perl](https://formulae.brew.sh/formula/perl)
* [perltidy](https://formulae.brew.sh/formula/perltidy)
* [ctags](https://formulae.brew.sh/formula/ctags)

#### nix

* [nixpkgs.perl528Packages.Perlcritic](https://nixos.org/nixos/packages.html?attr=perl528Packages.PerlCritic&channel=nixpkgs-unstable&query=perl528Packages.PerlCritic)

### MacOS software <a id="macos-software"></a>

#### brew <a id="brew-1"></a>

* ​[make](https://formulae.brew.sh/formula/make)
* [gcc](https://formulae.brew.sh/formula/gcc)
* [perl](https://formulae.brew.sh/formula/perl)
* [perltidy](https://formulae.brew.sh/formula/perltidy)
* [ctags](https://formulae.brew.sh/formula/ctags)

**nix**

* [nixpkgs.perl528Packages.Perlcritic](https://nixos.org/nixos/packages.html?attr=perl528Packages.PerlCritic&channel=nixpkgs-unstable&query=perl528Packages.PerlCritic)

## Documentation <a id="documentation"></a>

* ​[Perl](https://github.com/Kapeli/feeds/blob/master/Perl.xml)

## VSCode-Anywhere <a id="vscode-anywhere"></a>

### Environment <a id="environment"></a>

#### Windows environment

```yaml
PATH: C:\VSCode-Anywhere\apps\scoop\apps\perl\current\c\bin;C:\VSCode-Anywhere\apps\scoop\apps\perl\current\perl\bin;C:\VSCode-Anywhere\apps\scoop\apps\perl\current\perl\site\bin
```

#### Linux environment

No environment.

#### MacOS environment

No environment.

### Specific settings <a id="specific-settings"></a>

#### cpan

Allow to manage [cpan](https://www.cpan.org) packages.

* **`pkgs`**: name of the packages to install
  * `enabled`: `True` to `enable`, `False` to skip \(default to `False`\)
  * `version`: version of the cpan package



* **`opts`**

`opts` is not mandatory but allows to pass additional arguments.

Extra args can be arguments described in the [saltstack cpan states](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html) or can be [global saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).



Global `opts` packages settings:

* `cpan:pkgs:opts:global`: allow to pass arguments **to all cpan packages** when **installing**, **updating**, or **uninstalling** a package
*  `pm:pkgs:opts:install`: allow to pass arguments **to all cpan packages** when **installing** a package \(cf [states.cpan.installed](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html#salt.states.cpan.installed)\)
* `cpan:pkgs:opts:update`: allow to pass arguments **to all cpan packages** when **updating** a package \(cf [states.cpan.uptodate](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html#salt.states.cpan.uptodate)\)
* `cpan:pkgs:opts:uninstall`: allow to pass arguments **to all cpan packages** when **uninstalling** a package \(cf [states.cpan.removed](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html#salt.states.cpan.removed)\)

#### 

Specific `opts` packages settings:

* `cpan:pkgs:<mypkg>:opts:global`: allow to pass arguments **to** `<mypkg>` **cpan package** when **installing**, **updating**, or **uninstalling** the package
*  `cpan:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **cpan packages** when **installing** the package \(cf [states.cpan.installed](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html#salt.states.cpan.installed)\)
* `cpan:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **cpan packages** when **updating** the package \(cf [states.cpan.uptodate](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html#salt.states.cpan.uptodate)\)
* `cpan:pkgs:<mypkg>:opts:uninstall`: allow to pass arguments **to** `<mypkg>` **cpan packages** when **uninstalling** the package \(cf [states.cpan.removed](https://docs.saltstack.com/en/develop/ref/states/all/salt.states.cpan.html#salt.states.cpan.removed)\)



* Windows:

```yaml
vscode-anywhere:
  perl:
    cpan:
      opts:
        global:
          bin_env: C:\VSCode-Anywhere\apps\scoop\apps\perl\current\perl\bin\cpan.bat
        install: {}
        update: {}
        uninstall: {}
      pkgs:
        Perl::Tidy:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
        Perl::Critic:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            # uninstall: {}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

* Linux

```yaml
vscode-anywhere:
  perl:
    cpan:
      opts:
        global:
          bin_env: /home/linuxbrew/.linuxbrew/bin/cpan
        install: {}
        update: {}
        uninstall: {}
```

* MacOS

```yaml
vscode-anywhere:
  perl:
    cpan:
      opts:
        global:
          bin_env: /home/linuxbrew/.linuxbrew/bin/cpan
        install: {}
        update: {}
        uninstall: {}
```


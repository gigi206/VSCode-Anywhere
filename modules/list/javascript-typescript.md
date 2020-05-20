# JavaScript / TypeScript

![](https://upload.wikimedia.org/wikipedia/commons/9/99/Unofficial_JavaScript_logo_2.svg)

![](https://upload.wikimedia.org/wikipedia/commons/a/a6/TypeScript_Logo.png)

## About

[Javascript](https://www.oracle.com/java/) \(JS\) is a lightweight, interpreted, or just-in-time compiled programming language with first-class functions.

While it is most well-known as the scripting language for Web pages, many non-browser environments also use it, such as Node.js, Apache CouchDB and Adobe Acrobat.

JavaScript is a prototype-based, multi-paradigm, single-threaded, dynamic language, supporting object-oriented, imperative, and declarative \(e.g. functional programming\) styles.

## Installation

Change `enable` from `False` to `True` in the `javascript` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    javascript:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere javascript module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/javascript/defaults.yaml).
{% endhint %}

For more details read the [official documentation](https://code.visualstudio.com/docs/languages/javascript).

## Requirements

This module doesn’t work out of the box. You must configure [eslint](https://eslint.org/) \(extension [dbaeumer.vscode-eslint](https://vscode-anywhere.readthedocs.io/en/dev/modules/javascript.html#dbaeumer-vscode-eslint)\) for each project for it works properly.

## VSCode

### VSCode extensions

#### VisualStudioExptTeam.vscodeintellicode

This [extension](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode) provides AI-assisted development features for JavaScript/TypeScript.

![](https://docs.microsoft.com/en-us/visualstudio/intellicode/media/python-intellicode.gif)

#### dbaeumer.vscode-eslint

[ESLint](http://eslint.org/) support inside VS Code.

{% hint style="info" %}
This extension doesn’t work out of the box. You must configure it for each project for this extension works properly.

Please read the [documentation](https://eslint.org/docs/user-guide/configuring).
{% endhint %}

{% embed url="https://youtu.be/cMrDePs86Uo" caption="ESLint" %}

#### esbenp.prettier-vscode

[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) is an opinionated code formatter. It enforces a consistent style by parsing your code and re-printing it with its own rules that take the maximum line length into account, wrapping code when necessary.

#### eg2.vscode-npm-script

This [extension](https://marketplace.visualstudio.com/items?itemName=eg2.vscode-npm-script) running npm scripts defined in the package.json file and validating the installed modules against the dependencies defined in the package.json.

![](https://github.com/Microsoft/vscode-npm-scripts/raw/master/images/validation.png)

#### xabikos.JavaScriptSnippets

This [extension](https://marketplace.visualstudio.com/items?itemName=xabikos.JavaScriptSnippets) contains code snippets for JavaScript in ES6 syntax for Vs Code editor.

#### leizongmin.node-module-intellisense

This [extension](https://marketplace.visualstudio.com/items?itemName=leizongmin.node-module-intellisense) autocompletes JavaScript / TypeScript modules in import statements.

![](https://github.com/leizongmin/vscode-node-module-intellisense/raw/master/images/auto_complete.gif)

#### christian-kohler.npm-intellisense

This [extension](https://marketplace.visualstudio.com/items?itemName=christian-kohler.npm-intellisense) autocompletes filenames.

![](https://github.com/ChristianKohler/NpmIntellisense/raw/master/images/auto_complete.gif)

#### christian-kohler.path-intellisense

This [extension](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense) autocompletes npm modules in import statements.

![](http://i.giphy.com/iaHeUiDeTUZuo.gif)

#### msjsdiag.debugger-for-chrome

This [extension](https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome) allow to debug your JavaScript code in the Chrome browser, or any other target that supports the Chrome Debugger protocol.

![](https://github.com/Microsoft/vscode-chrome-debug/blob/master/images/demo.gif?raw=true)

#### wix.vscode-import-cost

This [extension](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost) allow to debug your JavaScript code in the Chrome browser, or any other target that supports the Chrome Debugger protocol.

![](https://file-wkbcnlcvbn.now.sh/import-cost.gif)

#### hbenl.vscode-mocha-test-adapter

[This extension](https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-mocha-test-adapter) allows to run your [Mocha](https://mochajs.org) tests using the [Test Explorer UI](https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-test-explorer).

![](https://github.com/hbenl/vscode-mocha-test-adapter/raw/master/img/screenshot.png)

### VSCode settings

#### Global settings

```javascript
{
   "eslint.alwaysShowStatus": true,
   "[javascript]":{
      "editor.defaultFormatter":"esbenp.prettier-vscode"
   },
   "[javascriptreact]":{
      "editor.defaultFormatter":"esbenp.prettier-vscode"
   },
   "[typescript]":{
      "editor.defaultFormatter":"esbenp.prettier-vscode"
   },
   "[typescriptreact]":{
      "editor.defaultFormatter":"esbenp.prettier-vscode"
   },
   "[vue]":{
      "editor.defaultFormatter":"esbenp.prettier-vscode"
   }
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows softwares

#### scoop

* [nodejs](https://github.com/ScoopInstaller/Main/blob/master/bucket/nodejs.json)

### Linux software

#### brew

* [node](https://formulae.brew.sh/formula/node)

### MacOS software

#### brew

* [node](https://formulae.brew.sh/formula/node)

## Documentation

* [JavaScript](https://github.com/Kapeli/feeds/blob/master/JavaScript.xml)
* [NodeJS](https://github.com/Kapeli/feeds/blob/master/NodeJS.xml)

## VSCode-Anywhere

### Environment

#### Windows environment

```yaml
PATH: "C:\VSCode-Anywhere\apps\scoop\apps\nodejs\current;C:\VSCode-Anywhere\apps\scoop\apps\nodejs\current\bin"
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

### Specific settings

#### npm\_bin

Path of the `npm` binary.

* Windows:

```yaml
vscode-anywhere:
    javascript:
        npm_binary: C:\VSCode-Anywhere\apps\scoop\apps\nodejs\current\npm.cmd
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

* Linux /MacOS:

```yaml
vscode-anywhere:
    javascript:
        npm_binary: /home/linuxbrew/.linuxbrew/bin/npm
```

#### npm

Allow to manage npm packages.

* `pkgs`: name of the packages to install
  * `enabled`: `True` to `enable`, `False` to skip \(default to `False`\)
  * `version`: version of the npm package



* opts

`opts` is not mandatory but allow to pass extra args.

Extra args can be arguments described in the [saltstack npm states](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html) or can be [global saltstack arguments](https://docs.saltstack.com/en/latest/ref/states/requisites.html).



Global `opts` packages settings:

* `npm:pkgs:opts:global`: allow to pass arguments **to all npm packages** when **installing**, **updating**, or **uninstalling** a package
*  `pm:pkgs:opts:install`: allow to pass arguments **to all npm packages** when **installing** a package \(cf [states.npm.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html#salt.states.npm.installed)\)
* `npm:pkgs:opts:update`: allow to pass arguments **to all npm packages** when **updating** a package \(cf [states.npm.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.upgraded) is also called during the update process\)
* `npm:pkgs:opts:uninstall`: allow to pass arguments **to all npm packages** when **uninstalling** a package \(cf [states.npm.removed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html#salt.states.npm.removed)\)

#### 

Specific `opts` packages settings:

* `npm:pkgs:<mypkg>:opts:global`: allow to pass arguments **to** `<mypkg>` **npm package** when **installing**, **updating**, or **uninstalling** the package
*  `npm:pkgs:<mypkg>:opts:install`: allow to pass arguments **to** `<mypkg>` **npm packages** when **installing** the package \(cf [states.npm.installed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html#salt.states.npm.installed)\)
* `npm:pkgs:<mypkg>:opts:update`: allow to pass arguments **to** `<mypkg>` **npm packages** when **updating** the package \(cf [states.npm.installed](https://docs.saltstack.com/en/master/ref/states/all/salt.states.chocolatey.html#salt.states.chocolatey.upgraded) is also called during the update process\)
* `npm:pkgs:<mypkg>:opts:uninstall`: allow to pass arguments **to** `<mypkg>` **npm packages** when **uninstalling** the package \(cf [states.npm.removed](https://docs.saltstack.com/en/latest/ref/states/all/salt.states.npm.html#salt.states.npm.removed)\)



* Windows:

```yaml
vscode-anywhere:
  javascript:
    npm:
      opts:
        global:
          env:
            - PATH: C:\VSCode-Anywhere\apps\scoop\apps\nodejs\current;C:\VSCode-Anywhere\apps\scoop\apps\nodejs\current\bin
        install: {}
        update: {}
        uninstall: {}
      pkgs:
        eslint:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
        mocha:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

* Linux / MacOS

```yaml
vscode-anywhere:
  javascript:
    npm:
      opts:
        global: {}
        install: {}
        update: {}
        uninstall: {}
      pkgs:
        eslint:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
        mocha:
          enabled: True
          version: null
          opts:
            install: {}
            update: {}
            uninstall: {}
```


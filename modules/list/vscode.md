# VSCode

![](https://upload.wikimedia.org/wikipedia/commons/9/9a/Visual_Studio_Code_1.35_icon.svg)

## About

This module installs additional extensions.

## Installation

Change `enable` from `False` to `True` in the `vscode` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    vscode:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere vscode module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/vscode/defaults.yaml).
{% endhint %}

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### xaver.theme-ysgrifennwr

[Ysgrifennwr](https://marketplace.visualstudio.com/items?itemName=xaver.theme-ysgrifennwr) is a light color theme.

![](https://github.com/xaverh/theme-ysgrifennwr/raw/master/screenshot.png)

{% hint style="info" %}
This extension is installed but not set as the default theme.
{% endhint %}

#### ginfuru.ginfuru-better-solarized-dark-theme

[Better Solarized](https://marketplace.visualstudio.com/items?itemName=ginfuru.ginfuru-better-solarized-dark-theme) is a modified version of the [Boxy Solarized Theme](https://github.com/ihodev/sublime-boxy) for Sublime Text, with the original Solarized Workbench theme for Visual Studio Code.

This theme includes 3 variants:

1. Solarized Light
2. Solarized Dark
3. Solarized Dark with Italics

![](https://raw.github.com/ginfuru/vscode-better-solarized-dark/master/images/ScreenShotD.png)

![](https://raw.github.com/ginfuru/vscode-better-solarized-dark/master/images/screenshotB.png)

{% hint style="info" %}
This extension is installed but not set as the default theme.
{% endhint %}

#### zhuangtongfa.Material-theme

[One Dark Pro](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme) is a dark color theme.

![](https://raw.githubusercontent.com/Binaryify/OneDark-Pro/master/static/screenshot2.png)

{% hint style="success" %}
This extension is set as the default theme.
{% endhint %}

#### vscode-icons-team.vscode-icons

[vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons) brings icons to your Visual Studio Code.

![](https://raw.githubusercontent.com/vscode-icons/vscode-icons/master/images/screenshot.gif)

{% hint style="success" %}
This extension is set as the default icon theme.
{% endhint %}

#### alefragnani.Bookmarks

[Bookmarks](https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks) is an extension created for Visual Studio Code. If you find it useful, please consider supporting it.

![](https://github.com/alefragnani/vscode-bookmarks/raw/master/images/printscreen-toggle.png)

#### alefragnani.project-manager

[Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager) helps you to easily access your projects, no matter where they are located.

![](https://github.com/alefragnani/vscode-project-manager/raw/master/images/vscode-project-manager-side-bar.gif)

#### christian-kohler.path-intellisense

[Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense) is a plugin that autocompletes filenames.

![](https://i.giphy.com/iaHeUiDeTUZuo.gif)

#### CoenraadS.bracket-pair-colorizer

[Bracket Pair Colorizer](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer) allows matching brackets to be identified with colours. The user can define which characters to match, and which colours to use.

![](https://github.com/CoenraadS/BracketPair/raw/master/images/activeScopeBackground.png)

#### formulahendry.code-runner

[Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner) can run code snippet or code file for multiple languages.

![](https://github.com/formulahendry/vscode-code-runner/raw/master/images/usage.gif)

#### spmeesseman.vscode-taskexplorer

[Task Explorer](https://marketplace.visualstudio.com/items?itemName=spmeesseman.vscode-taskexplorer) allow to manage tasks for npm, vscode, ant, gradle, grunt, gulp, batch, bash, make, python, perl, powershell, ruby, and nsis.

For more information about tasks, [please read the documentation](https://code.visualstudio.com/docs/editor/tasks).

![](https://github.com/spmeesseman/vscode-taskexplorer/raw/master/res/taskview5.png?raw=true)

#### spywhere.guides

[Guides](https://marketplace.visualstudio.com/items?itemName=spywhere.guides) is simply an extension that add various indentation guide lines.

![](https://github.com/spywhere/vscode-guides/raw/master/images/screenshot.png)

#### ybaumes.highlight-trailing-white-spaces

[Highlight Trailing White Spaces](https://marketplace.visualstudio.com/items?itemName=ybaumes.highlight-trailing-white-spaces) highlight in red color trailing white spaces.

![](https://github.com/yifu/highlight-trailing-whitespaces/raw/master/illustration.gif)

#### Rubymaniac.vscode-paste-and-indent

[Paste and Indent](https://marketplace.visualstudio.com/items?itemName=Rubymaniac.vscode-paste-and-indent) adds limited support for pasting and indenting code.

#### Gruntfuggly.todo-tree

[Todo Tree](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree) quickly searches your workspace for comment tags like **TODO** and **FIXME**, and displays them in a tree view in the explorer pane.

![](https://raw.githubusercontent.com/Gruntfuggly/todo-tree/master/resources/screenshot.png)

#### axosoft.gitkraken-glo

[GitKraken Glo](https://marketplace.visualstudio.com/items?itemName=axosoft.gitkraken-glo) is an issue board for tracking issues and tasks.

![](https://user-images.githubusercontent.com/899916/37066976-01877280-2165-11e8-87ff-d6b04e1d9ca5.png)

### VSCode settings

#### Global settings

```javascript
{
  "workbench.colorTheme": "One Dark Pro",
  "workbench.iconTheme": "vscode-icons",
  "vsicons.dontShowNewVersionMessage": true,
  "code-runner.respectShebang": false,
  "editor.renderIndentGuides": false,
  "todo-tree.highlights.customHighlight": {
    "TODO": {
      "icon": "check",
      "fontWeight": 90,
      "foreground": "white",
      "background": "magenta",
      "opacity": 5,
      "iconColour": "pink"
    },
    "FIXME": {
      "icon": "alert",
      "fontWeight": 900,
      "foreground": "white",
      "background": "yellow",
      "opacity": 50,
      "iconColour": "yellow"
    }
  },
  "window.titleBarStyle": "custom",
  "window.menuBarVisibility": "toggle",
  "workbench.colorCustomizations": {
    "[Ysgrifennwr]": {
      "statusBar.background": "#edece8",
      "statusBar.foreground": "#42424280"
    },
    "[One Dark Pro]": {
      "editor.selectionHighlightBackground": "#ffffff10",
      "editor.selectionHighlightBorder": "#ffffff10"
    }
  }
}
```

### VSCode keybindings <a id="vscode-keybindings"></a>

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software <a id="software"></a>

### Windows software <a id="windows-software"></a>

No software.

## Documentation <a id="documentation"></a>

No documentation.

## VSCode-Anywhere <a id="vscode-anywhere"></a>

### Environment <a id="environment"></a>

No environment.

### Specific settings <a id="specific-settings"></a>

No specific settings.


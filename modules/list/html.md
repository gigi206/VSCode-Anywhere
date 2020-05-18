---
description: HTML / CSS / Sass / Less /Emmet
---

# HTML

![](https://upload.wikimedia.org/wikipedia/commons/6/61/HTML5_logo_and_wordmark.svg)

## About

[Hypertext Markup Language](https://html.spec.whatwg.org/) \(HTML\) is the standard markup language for documents designed to be displayed in a web browser. It can be assisted by technologies such as Cascading Style Sheets CSS and scripting languages such as [JavaScript](https://vscode-anywhere.readthedocs.io/en/dev/modules/javascript.html#module-javascript).

## Installation

Change `enable` from `False` to `True` in the `html` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    html:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere html module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/html/defaults.yaml).
{% endhint %}

For more details, read the the official documentation [HTML](https://code.visualstudio.com/docs/languages/html) and [CSS / SCSS / Less](https://code.visualstudio.com/docs/languages/css).

VSCode includes a native support of [emmet](https://code.visualstudio.com/docs/editor/emmet).

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### Zignd.html-css-class-completion

[This extension](https://marketplace.visualstudio.com/items?itemName=ecmel.vscode-html-css) adds CSS support for HTML documents.

#### Zignd.html-css-class-completion

[This extension](https://marketplace.visualstudio.com/items?itemName=Zignd.html-css-class-completion) that provides CSS class name completion for the HTML class attribute based on the definitions found in your workspace for external files referenced through the link element.

![](https://i.imgur.com/5crMfTj.gif)

#### pranaygp.vscode-css-peek

[This extension](https://marketplace.visualstudio.com/items?itemName=pranaygp.vscode-css-peek) extends HTML and ejs code editing with Go To Definition and Go To Symbol in Workspace support for css/scss/less \(classes and IDs\) found in strings within the source code.

![](https://github.com/pranaygp/vscode-css-peek/raw/master/working.gif)

#### bradgashler.htmltagwrap

[This extension](https://marketplace.visualstudio.com/items?itemName=bradgashler.htmltagwrap) allow to wrap your selection in HTML tags. Can wrap inline selections and selections that span multiple lines \(works with both single selections and multiple selections at once\).

![](https://github.com/bgashler1/vscode-htmltagwrap/raw/master/images/screenshot.gif)

#### Umoxfo.vscode-w3cvalidation

[This extension](https://marketplace.visualstudio.com/items?itemName=Umoxfo.vscode-w3cvalidation) enable W3C validation support by the [Nu Html Checker library](https://validator.github.io/validator/).

Extension highlights wrong properties and values when enabled. Just install the extension and open your CSS file. Validation will be performing in background.

#### vincaslt.highlight-matching-tag

[This extension](https://marketplace.visualstudio.com/items?itemName=vincaslt.highlight-matching-tag) is intended to provide the missing functionality that should be built-in out of the box in VSCode - to highlight matching opening or closing tags.

![](https://images2.imgbox.com/71/2a/zIA1XCzK_o.gif)

#### formulahendry.auto-rename-tag

[This extension](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag) Automatically rename paired HTML/XML tag.

![](https://github.com/formulahendry/vscode-auto-rename-tag/raw/master/images/usage.gif)

#### mrmlnc.vscode-autoprefixer

[This extension](https://marketplace.visualstudio.com/items?itemName=mrmlnc.vscode-autoprefixer) provides an interface to [autoprefixer](https://github.com/postcss/autoprefixer).

![](https://cloud.githubusercontent.com/assets/7034281/16823311/da82a3c6-496b-11e6-8d95-0bebbf0b9607.gif)

#### esbenp.prettier-vscode

[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) is an opinionated code formatter. It enforces a consistent style by parsing your code and re-printing it with its own rules that take the maximum line length into account, wrapping code when necessary.

#### naumovs.color-highlight

[This extension](https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight) styles css/web colors found in your document.

![](https://naumovs.gallerycdn.vsassets.io/extensions/naumovs/color-highlight/2.3.0/1499789961213/Microsoft.VisualStudio.Services.Icons.Default)

#### smelukov.vscode-csstree

[CSSTree validator](https://marketplace.visualstudio.com/items?itemName=smelukov.vscode-csstree) validates CSS according to W3C specs and browser implementations.

![](https://cloud.githubusercontent.com/assets/6654581/18788246/d0d4c7ca-81ae-11e6-9777-36806fd4cbfb.png)

### VSCode settings

#### Global settings

```javascript
{
    "[html]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[css]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[scss]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[less]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    }
}
```

#### Windows settings

```javascript
{
    "vscode-w3cvalidation.javaHome": "C:\\VSCode-Anywhere\\apps\\openjdk\\current"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "vscode-w3cvalidation.javaHome": "/home/linuxbrew/.linuxbrew/opt/openjdk/libexec"
}
```

#### MacOS settings

```javascript
{
    "vscode-w3cvalidation.javaHome": "/home/linuxbrew/.linuxbrew/opt/openjdk/libexec"
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### scoop

* [openjdk](https://github.com/ScoopInstaller/Main/blob/master/bucket/python.json) \(required by the extensions [Umoxfo.vscode-w3cvalidation](https://marketplace.visualstudio.com/items?itemName=Umoxfo.vscode-w3cvalidation)\).

### Linux software

#### brew

* [openjdk](https://formulae.brew.sh/formula/openjdk) \(required by the extensions [Umoxfo.vscode-w3cvalidation](https://marketplace.visualstudio.com/items?itemName=Umoxfo.vscode-w3cvalidation)\).

### MacOS software

#### brew

* [openjdk](https://formulae.brew.sh/formula/openjdk) \(required by the extensions [Umoxfo.vscode-w3cvalidation](https://marketplace.visualstudio.com/items?itemName=Umoxfo.vscode-w3cvalidation)\).

## Documentation

* [HTML](https://github.com/Kapeli/feeds/blob/master/HTML.xml)
* [CSS](https://github.com/Kapeli/feeds/blob/master/CSS.xml)
* [Emmet](https://github.com/Kapeli/feeds/blob/master/Emmet.xml)
* [Saas](https://github.com/Kapeli/feeds/blob/master/Sass.xml)
* [Less](https://github.com/Kapeli/feeds/blob/master/Less.xml)

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

No specific settings.


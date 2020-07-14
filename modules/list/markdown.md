# Markdown

![](https://upload.wikimedia.org/wikipedia/commons/4/48/Markdown-mark.svg)

## About

[Markdown](https://daringfireball.net/projects/markdown/) is a lightweight markup language with plain text formatting syntax.

Its design allows it to be converted to many output formats, but the original tool by the same name only supports HTML. Markdown is often used to format readme files, for writing messages in online discussion forums, and to create rich text using a plain text editor.

## Installation

Change `enable` from `False` to `True` in the `markdown` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    markdown:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere markdown module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/markdown/defaults.yaml).
{% endhint %}

For more details read the [official documentation](https://code.visualstudio.com/docs/languages/markdown).

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### yzhang.markdown-all-in-one

This [extension](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one) is all you need for Markdown \(keyboard shortcuts, table of contents, auto preview and more\).

![](https://github.com/yzhang-gh/vscode-markdown/raw/master/images/toc.png)

#### esbenp.prettier-vscode

[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) is an opinionated code formatter. It enforces a consistent style by parsing your code and re-printing it with its own rules that take the maximum line length into account, wrapping code when necessary.

### VSCode settings <a id="vscode-settings"></a>

```javascript
{
	"[markdown]": {
		"editor.defaultFormatter": "esbenp.prettier-vscode"
	}
}
```

### VSCode keybindings <a id="vscode-keybindings"></a>

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software <a id="software"></a>

No software.

## Documentation <a id="documentation"></a>

* [Markdown](https://github.com/Kapeli/feeds/blob/master/Markdown.xml)

## VSCode-Anywhere <a id="vscode-anywhere"></a>

### Environment <a id="environment"></a>

No environment.

### Specific settings <a id="specific-settings"></a>

No specific settings.

## 


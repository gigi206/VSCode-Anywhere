---
description: Fira Code
---

# Fonts

![ligatures](https://github.com/tonsky/FiraCode/raw/master/showcases/v3/all_ligatures.png)

## About

This module install the [Fira Code](https://github.com/tonsky/FiraCode/) fonts and configure VSCode to use these fonts and enable ligatures.

[Fira Code](https://github.com/tonsky/FiraCode/) is an extension of the Fira Mono font containing a set of ligatures for common programming multi-character combinations.

![](https://code.visualstudio.com/assets/docs/getstarted/tips-and-tricks/font-ligatures-annotated.png)

## Requirements

No requirements.

## VSCode

### VSCode extensions

No [extensions](https://marketplace.visualstudio.com/VSCode).

### VSCode settings

```javascript
{
      "editor.fontLigatures": true,
      "editor.fontFamily:" "Fira Code"
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

No software.

## Documentation

* No documentation.

## VSCode-Anywhere

### Environment

No environment.

### Specific settings

### fonts

The setting `fonts` allow to install some fonts.

`FiraCode` is the name of the font to install and it takes some params:

* `provider`: machanism to download the fonts \(only `git` at the moment\)
* `url`: where to downlod the fonts \(depending of the `provider`\)
* `files`: list of files that must be synchronised

```yaml
vscode-anywhare:
  fonts:
    enabled: False
    fonts:
      FiraCode:
          provider: git
          url: https://github.com/tonsky/FiraCode.git
          files:
            - distr/ttf/FiraCode-Bold.ttf
            - distr/ttf/FiraCode-Light.ttf
            - distr/ttf/FiraCode-Medium.ttf
            - distr/ttf/FiraCode-Regular.ttf
            - distr/ttf/FiraCode-Retina.ttf
            - distr/ttf/FiraCode-SemiBold.ttf
```


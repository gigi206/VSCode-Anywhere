# Go

![](https://golang.org/lib/godoc/images/go-logo-blue.svg)

## About

[Go](https://golang.org/) is an open source programming language that makes it easy to build simple, reliable, and efficient software.

## Installation

Change `enable` from `False` to `True` in the `go` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    ansible:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere go module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/go/defaults.yaml).
{% endhint %}

For more details read the [official documentation](https://code.visualstudio.com/docs/languages/go).

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### ms-vscode.go

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.go) adds rich language support for the Go language to VS Code.

![](https://code.visualstudio.com/assets/docs/languages/go/hover.png)

### VSCode settings

#### Global settings

```javascript
{
    "go.lintTool": "gometalinter"
}
```

#### Windows settings

```javascript
{
    "go.goroot": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\go\\current",
    "go.gopath": "C:\\VSCode-Anywhere\\apps\\scoop\\persist\\go"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "go.goroot": "/home/linuxbrew/.linuxbrew/opt/go/libexec",
    "go.gopath": "/home/myuser/VSCode-Anywhere/apps/vscode-anywhere/go"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### scoop

* [go](https://github.com/ScoopInstaller/Main/blob/master/bucket/go.json)

#### msys2

* [mingw-w64-x86\_64-gcc](https://packages.msys2.org/package/mingw-w64-x86_64-gcc)

### Linux software

#### brew

* [go](https://formulae.brew.sh/formula/go)

### MacOS software

#### brew

* [go](https://formulae.brew.sh/formula/go)

## Documentation

* [Go](https://github.com/Kapeli/feeds/blob/master/Go.xml)

## VSCode-Anywhere

### Environment

#### Windows environment

```yaml
GOROOT: C:\VSCode-Anywhere\apps\scoop\apps\go\current
GOPATH: C:\VSCode-Anywhere\apps\scoop\persist\go
PATH: C:\VSCode-Anywhere\apps\scoop\persist\go\bin
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux environment

```yaml
GOROOT: /home/linuxbrew/.linuxbrew/opt/go/libexec
GOPATH: /home/myuser/VSCode-Anywhere/apps/vscode-anywhere/go
```

{% hint style="info" %}
Assuming you have installed in the default directory `/home/myuser/VSCode-Anywhere`.
{% endhint %}

### Specific settings

#### go\_bin

Specify the path to the `go` binary.

* Windows:

```yaml
vscode-anywhere:
  go:
    go_bin: C:\VSCode-Anywhere\apps\scoop\shims\go.ps1
```

* Linux / MacOS

```yaml
vscode-anywhere:
  go:
    go_bin: /home/linuxbrew/.linuxbrew/bin/go
```

#### modules

For each module you must specify the path like `github.com/ramya-rao-a/go-outline`.

* `enabled`: enabled the module
* `version`:  the version of the module to install

Below are all `go` modules installed by SCode-Anywhere:

```yaml
vscode-anywhere:
  go:
    modules:
      github.com/ramya-rao-a/go-outline:
        enabled: True
        version: null
      github.com/acroca/go-symbols:
        enabled: True
        version: null
      github.com/stamblerre/gocode:
        enabled: True
        version: null
      github.com/mdempsky/gocode:
        enabled: True
        version: null
      github.com/rogpeppe/godef:
        enabled: True
        version: null
      golang.org/x/tools/cmd/godoc:
        enabled: True
        version: null
      github.com/zmb3/gogetdoc:
        enabled: True
        version: null
      golang.org/x/lint/golint:
        enabled: True
        version: null
      github.com/fatih/gomodifytags:
        enabled: True
        version: null
      github.com/uudashr/gopkgs/cmd/gopkgs:
        enabled: True
        version: null
      golang.org/x/tools/cmd/gorename:
        enabled: True
        version: null
      github.com/sqs/goreturns:
        enabled: True
        version: null
      golang.org/x/tools/cmd/goimports:
        enabled: True
        version: null
      github.com/cweill/gotests:
        enabled: True
        version: null
      golang.org/x/tools/cmd/guru:
        enabled: True
        version: null
      github.com/josharian/impl:
        enabled: True
        version: null
      github.com/haya14busa/goplay/cmd/goplay:
        enabled: True
        version: null
      github.com/alecthomas/gometalinter:
        enabled: True
        version: null
      github.com/tylerb/gotype-live:
        enabled: True
        version: null
      # github.com/sourcegraph/go-langserver:
      #   enabled: True
      #   version: null
      github.com/go-delve/delve/cmd/dlv:
        enabled: True
        version: null
      github.com/golangci/golangci-lint/cmd/golangci-lint:
        enabled: True
        version: null
      github.com/mgechev/revive:
        enabled: True
        version: null
      honnef.co/go/tools/cmd/staticcheck:
        enabled: True
        version: null
      github.com/davidrjenni/reftools/cmd/fillstruct:
        enabled: True
        version: null
      github.com/godoctor/godoctor:
        enabled: True
        version: null
```


# C / C++

![](https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/ISO_C%2B%2B_Logo.svg/131px-ISO_C%2B%2B_Logo.svg.png)

## About

This module contains 2 languages:

* [C](https://en.cppreference.com/w/c) is a general-purpose, procedural computer programming language supporting structured programming, lexical variable scope, and recursion, while a static type system prevents unintended operations.
* [C++](https://en.cppreference.com/w/cpp) is a general-purpose programming language created by Bjarne Stroustrup as an extension of the C programming language, or _C with Classes_.

## Installation

Change `enable` from `False` to `True` in the `c_cpp` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    c_cpp:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere c\_cpp module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/c_cpp/defaults.yaml).
{% endhint %}

## Requirements

After installing this module, you must configure it because it doesn't work out of the box.

Indeed to work the module **ms-vscode.cpptools**  needs to have a valid`.vscode/c_cpp_properties.json` file.

You can use the C/C++ configuration UI by running the command **C/C++: Edit Configurations \(UI\)** from the Command Palette \(`Ctrl+Shift+P`\).

![C/C++: Edit Configurations \(UI\)](https://code.visualstudio.com/assets/docs/cpp/cpp/command-palette.png)

For more details read [the official configuration](https://code.visualstudio.com/docs/languages/cpp) and how to configure it with:

* [Mingw on Windows](https://code.visualstudio.com/docs/cpp/config-mingw)
* [GCC with Windows Subsystem for Linux](https://code.visualstudio.com/docs/cpp/config-wsl)
* [GCC on Linux](https://code.visualstudio.com/docs/cpp/config-linux)
* [Clang on MacOS](https://code.visualstudio.com/docs/cpp/config-clang-mac)

You could also read:

* [Debugging](https://code.visualstudio.com/docs/cpp/cpp-debug)
* [Editing](https://code.visualstudio.com/docs/cpp/cpp-ide)
* [Settings](https://code.visualstudio.com/docs/cpp/customize-default-settings-cpp)
* [c\_cpp\_properties.json](https://code.visualstudio.com/docs/cpp/c-cpp-properties-schema-reference)

### Windows examples

You can also create a [task](https://code.visualstudio.com/docs/editor/tasks) file `.vscode/tasks.json` to compile your program:

```javascript
{
    "version": "2.0.0",
    "tasks": [
        {
            "type": "shell",
            "label": "clang build active file",
            "command": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe",
            "args": [
                "-std=c11",
                "-Wall",
                "-Wextra",
                "-g",
                "${file}",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe"
            ],
            "options": {
                "cwd": "${workspaceFolder}"
            }
        },
        {
            "type": "shell",
            "label": "clang++ build active file",
            "command": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang++.exe",
            "args": [
                "-std=c++17",
                "-Wall",
                "-Wextra",
                "-g",
                "${file}",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe"
            ],
            "options": {
                "cwd": "${workspaceFolder}"
            }
        }
    ]
}
```

You can also create the `.vscode/launch.json` file to run the [debugger](https://code.visualstudio.com/docs/editor/debugging):

```javascript
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(gdb) clang",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}\\${fileBasenameNoExtension}.exe",
            "args": [],
            "stopAtEntry": true,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\gdb.exe",
            "setupCommands": [
                {
                    "description": "Activer l'impression en mode Pretty pour gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "clang build active file"
        },
        {
            "name": "(gdb) clang++",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}\\${fileBasenameNoExtension}.exe",
            "args": [],
            "stopAtEntry": true,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\gdb.exe",
            "setupCommands": [
                {
                    "description": "Activer l'impression en mode Pretty pour gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "clang++ build active file"
        }
    ]
}
```

{% hint style="info" %}
There are examples and assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

## VSCode

### VSCode extensions

#### ms-vscode.cpptools

This [extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) adds language support for C/C++ to Visual Studio Code, including features such as [IntelliSense](https://code.visualstudio.com/docs/editor/intellisense) and [debugging](https://code.visualstudio.com/docs/editor/debugging).

![C++ completion](https://code.visualstudio.com/assets/docs/languages/cpp/cpp-hero.png)

#### jbenden.c-cpp-flylint

This [extension](https://marketplace.visualstudio.com/items?itemName=jbenden.c-cpp-flylint) is an advanced, modern, static analysis extension for C/C++ that supports a number of back-end analyzer programs.

#### matepek.vscode-catch2-test-adapter

This [extension](https://marketplace.visualstudio.com/items?itemName=matepek.vscode-catch2-test-adapter) allows you to run your [Catch2](https://github.com/catchorg/Catch2), [Google Test](https://github.com/google/googletest) and [doctest](https://github.com/onqtam/doctest) \(experimental\) tests for Visual Studio Code.

![Cpp tests](https://github.com/matepek/vscode-catch2-test-adapter/raw/master/resources/Screenshot_2019-05-28.png)

{% hint style="info" %}
VSCode-Anywhere does not install Catch2, Google Test or doctest. You have to install them by yourself.
{% endhint %}

### VSCode settings

#### Global settings

```javascript
{
    "dash.languageIdToDocsetMap.c": [
        "c"
    ],
    "C_Cpp.default.cStandard": "c11",
    "C_Cpp.default.cppStandard": "c++17",
    "c-cpp-flylint.flexelint.enable": true,
    "c-cpp-flylint.cppcheck.enable": true,
    "c-cpp-flylint.clang.enable": false
}
```

If `llvm` is enabled:

```javascript
{
    "c-cpp-flylint.flexelint.enable": false,
    "c-cpp-flylint.cppcheck.enable": false,
    "c-cpp-flylint.clang.enable": true
}
```

#### Windows settings

```javascript
{
    "C_Cpp.default.compilerPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\gcc.exe",
    "c-cpp-flylint.clang.executable": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\g++.exe",
    "code-runner.executorMap.c": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\gcc.exe $fileName -o $fileNameWithoutExt.exe && $fileNameWithoutExt.exe",
    "code-runner.executorMap.cpp": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\g++.exe $fileName -o $fileNameWithoutExt.exe && $fileNameWithoutExt.exe",
    "c-cpp-flylint.cppcheck.executable": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\cppcheck.exe"
}
```

If `llvm` is enabled:

```javascript
{
    "C_Cpp.default.compilerPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe",
    "c-cpp-flylint.clang.executable": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe",
    "code-runner.executorMap.c": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang.exe $fileName -o $fileNameWithoutExt.exe && $fileNameWithoutExt.exe",
    "code-runner.executorMap.cpp": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\msys2\\current\\mingw64\\bin\\clang++.exe $fileName -o $fileNameWithoutExt.exe && $fileNameWithoutExt.exe"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "code-runner.executorMap.c": "/home/linuxbrew/.linuxbrew/bin/gcc $fileName -o $fileNameWithoutExt && $fileNameWithoutExt",
    "code-runner.executorMap.cpp": "/home/linuxbrew/.linuxbrew/bin/g++ $fileName -o $fileNameWithoutExt && $fileNameWithoutExt",
    "C_Cpp.default.compilerPath": "/home/linuxbrew/.linuxbrew/bin/gcc",
    "c-cpp-flylint.cppcheck.executable": "/home/linuxbrew/.linuxbrew/bin/cppcheck"
}
```

If `llvm` is enabled:

```javascript
{
    "code-runner.executorMap.c": "/home/linuxbrew/.linuxbrew/bin/clang $fileName -o $fileNameWithoutExt && $fileNameWithoutExt",
    "code-runner.executorMap.cpp": "/home/linuxbrew/.linuxbrew/bin/clang++ $fileName -o $fileNameWithoutExt && $fileNameWithoutExt",
    "C_Cpp.default.compilerPath": "/home/linuxbrew/.linuxbrew/bin/clang",
    "c-cpp-flylint.clang.executable": "/home/linuxbrew/.linuxbrew/bin/clang"
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

**msys2**

if `llvm` is disable:

* [mingw-w64-x86\_64-gcc](https://packages.msys2.org/package/mingw-w64-x86_64-gcc)
* [mingw-w64-x86\_64-gdb](https://packages.msys2.org/package/mingw-w64-x86_64-gdb)
* [mingw-w64-x86\_64-cppcheck](https://packages.msys2.org/package/mingw-w64-x86_64-cppcheck)

if `llvm` is enabled:

* [mingw-w64-x86\_64-clang](https://packages.msys2.org/package/mingw-w64-x86_64-clang)
* [mingw-w64-x86\_64-lldb](https://packages.msys2.org/package/mingw-w64-x86_64-lldb)

### Linux software

#### brew

If `llvm` is disable:

* [gcc](https://formulae.brew.sh/formula/gcc)
* [gdb](https://formulae.brew.sh/formula/gdb)
* [cppcheck](https://formulae.brew.sh/formula/cppcheck)

If `llvm` is enabled:

* [llvm](https://formulae.brew.sh/formula/llvm)

### MacOS software

#### brew

If `llvm` is disable:

* [gcc](https://formulae.brew.sh/formula/gcc)
* [gdb](https://formulae.brew.sh/formula/gdb)
* [cppcheck](https://formulae.brew.sh/formula/cppcheck)

If `llvm` is enabled:

* [llvm](https://formulae.brew.sh/formula/llvm)

## Documentation

* [C](https://github.com/Kapeli/feeds/blob/master/C.xml)
* [C++](https://github.com/Kapeli/feeds/blob/master/C%2B%2B.xml)

## VSCode-Anywhere

### Environment

### Windows environment

No environment.

### Linux environment

### Specific settings

#### llvm

To enable [llvm](https://llvm.org), set `llvm` to `True`.

```yaml
vscode-anywhere:
  c_cpp:
    enabled: False
    llvm: True
```


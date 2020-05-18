# Java

![](https://upload.wikimedia.org/wikipedia/fr/2/2e/Java_Logo.svg)

## About

[Java](https://www.oracle.com/java/) Java is a general-purpose programming language that is class-based, object-oriented, and designed to have as few implementation dependencies as possible.

## Installation

Change `enable` from `False` to `True` in the `java` section \(cf [module installation](../install.md)\).

```yaml
vscode-anywhere:
    java:
        enabled: True
```

{% hint style="info" %}
You can also take a look at the [VSCode-Anywhere java module configuration](https://github.com/gigi206/VSCode-Anywhere/blob/V2/salt/modules/java/defaults.yaml).
{% endhint %}

## Requirements

No requirements.

## VSCode

### VSCode extensions

#### redhat.java

This [extension](https://marketplace.visualstudio.com/items?itemName=redhat.java) provides Java language support.

![](https://raw.githubusercontent.com/redhat-developer/vscode-java/master/images/vscode-java.0.0.1.gif)

#### vscjava.vscode-java-debug

This [extension](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug) provides a lightweight Java debugger for Visual Studio Code.

![](https://github.com/VSChina/vscode-ansible/raw/master/images/menu.png)

#### vscjava.vscode-java-test

This [extension](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug) allow to run and debug Java test cases in Visual Studio Code.

![](https://github.com/Microsoft/vscode-java-test/raw/master/demo/demo.gif)

#### vscjava.vscode-maven

This [extension](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-maven) allow to manage Maven projects, execute goals, generate project from archetype, improve user experience for Java developers.

![](https://github.com/Microsoft/vscode-maven/raw/master/images/explorer.png)

#### vscjava.vscode-java-dependency

This [extension](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-dependency) manages Java Dependencies in VSCode.

![](https://raw.githubusercontent.com/Microsoft/vscode-java-dependency/master/images/project-dependency.gif)

#### VisualStudioExptTeam.vscodeintellicode

This [extension](https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode) provides AI-assisted development features for Java.

![](https://go.microsoft.com/fwlink/?linkid=2006041)

#### shengchen.vscode-checkstyle

This [extension](https://marketplace.visualstudio.com/items?itemName=shengchen.vscode-checkstyle) provides real-time feedback about Checkstyle violations and quick fix actions.

![](https://raw.githubusercontent.com/jdneo/vscode-checkstyle/master/docs/gifs/demo.gif)

#### redhat.vscode-xml

This [extension](https://marketplace.visualstudio.com/items?itemName=shengchen.vscode-checkstyle) provides support for creating and editing XML documents, based on the LSP4XML Language Server, running with Java.

![](https://user-images.githubusercontent.com/148698/45977901-df208a80-c018-11e8-85ec-71c70ba8a5ca.gif)

#### pivotal.vscode-spring-boot

This [extension](https://marketplace.visualstudio.com/items?itemName=pivotal.vscode-spring-boot) provides validation and content assist for Spring Boot `application.properties`, `application.yml` properties files. As well as Boot-specific support for `.java` files.

![](https://github.com/spring-projects/sts4/raw/facac2003191bc29bf79049aa02a091457ffbe47/vscode-extensions/vscode-spring-boot/readme-imgs/java-code-completion.png)

{% hint style="info" %}
This extension will be installed only if you had set `spring_boot` to `True` in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
    java:
    enabled: True
    spring_boot: True
```
{% endhint %}

#### vscjava.vscode-spring-initializr

This [extension](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-initializr) quickly generate a Spring Boot project in Visual Studio Code \(VS Code\). It helps you to customize your projects with configurations and manage Spring Boot dependencies.

![](https://github.com/Microsoft/vscode-spring-initializr/raw/master/images/spring-initializr-vsc.gif)

{% hint style="info" %}
This extension will be installed only if you had set `spring_boot` to `True` in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
    java:
        enabled: True
        spring_boot: True
```
{% endhint %}

#### vscjava.vscode-spring-boot-dashboard

[Spring Boot Dashboard](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-spring-boot-dashboard) is an explorer in the side bar, you can view and manage all available Spring Boot projects in your workspace. It also supports the features to quickly start, stop or debug a Spring Boot project.

![](https://github.com/Microsoft/vscode-spring-boot-dashboard/raw/master/images/boot-dashboard-vsc.gif)

{% hint style="info" %}
This extension will be installed only if `spring_boot` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
    java:
        enabled: True
        spring_boot: True
```
{% endhint %}

#### redhat.vscode-quarkus

This [extension](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-quarkus) provides support for Quarkus development.

![](https://github.com/redhat-developer/vscode-quarkus/raw/master/images/propertiesSupport.png)

{% hint style="info" %}
This extension will be installed only if `quarkus` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
    java:
        enabled: True
        quarkus: True
```
{% endhint %}

#### SummerSun.vscode-jetty

This [extension](https://marketplace.visualstudio.com/items?itemName=SummerSun.vscode-jetty) allow to start and run or debug your war package on Jetty.

![](https://github.com/summersun/vscode-jetty/raw/master/resources/Jetty.gif)

{% hint style="info" %}
This extension will be installed only if `jetty` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
    java:
        enabled: True
        jetty: True
```
{% endhint %}

#### adashen.vscode-tomcat

This [extension](https://marketplace.visualstudio.com/items?itemName=adashen.vscode-tomcat) allow to debug or run your java war package in Apache Tomcat.

![](https://github.com/adashen/vscode-tomcat/raw/master/resources/Tomcat.gif)

{% hint style="info" %}
This extension will be installed only if `jetty` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file:

```yaml
vscode-anywhere:
    java:
        enabled: True
        tomcat: True
```
{% endhint %}

### VSCode settings

#### Global settings

```javascript
{
    "java.semanticHighlighting.enabled": true
}
```

#### Windows settings

```javascript
{
    "java.home": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\openjdk\\current",
    "xml.java.home": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\openjdk\\current"
}
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux settings

```javascript
{
    "java.home": "/home/linuxbrew/.linuxbrew/opt/openjdk/libexec",
    "xml.java.home": "/home/linuxbrew/.linuxbrew/opt/openjdk/libexec"
}
```

#### MacOS settings

```javascript
{
    "java.home": "/home/linuxbrew/.linuxbrew/opt/openjdk/libexec",
    "xml.java.home": "/home/linuxbrew/.linuxbrew/opt/openjdk/libexec"
}
```

### VSCode keybindings

No [keybindings](https://code.visualstudio.com/docs/getstarted/keybindings).

## Software

### Windows software

#### scoop

* [openjdk](https://github.com/ScoopInstaller/Java/blob/master/bucket/openjdk.json)
* [maven](https://github.com/ScoopInstaller/Main/blob/master/bucket/maven.json)
* [gradle](https://github.com/ScoopInstaller/Main/blob/master/bucket/gradle.json)
* [tomcat](https://github.com/lukesampson/scoop-extras/blob/master/bucket/tomcat.json)

{% hint style="info" %}
This package will be installed only if `tomcat` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

* [graalvm](https://github.com/ScoopInstaller/Java/blob/master/bucket/graalvm.json)

{% hint style="info" %}
This package will be installed only if `quarkus` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

#### chocolatey

* [jetty](https://chocolatey.org/packages/jetty)

{% hint style="info" %}
This package will be installed only if you had set `jetty` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

### Linux software

#### brew

* [openjdk](https://formulae.brew.sh/formula/openjdk)
* [maven](https://formulae.brew.sh/formula/maven)
* [maven-completion](https://formulae.brew.sh/formula/maven-completion)
* [maven-shell](https://formulae.brew.sh/formula/maven-shell)
* [gradle](https://formulae.brew.sh/formula/gradle)
* [gradle-completion](https://formulae.brew.sh/formula/gradle-completion)
* [jetty](https://formulae.brew.sh/formula/jetty)

{% hint style="info" %}
This package will be installed only if `jetty` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

* [tomcat](https://formulae.brew.sh/formula/tomcat)

{% hint style="info" %}
This package will be installed only if `tomcat` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

#### nix

* [graalvm11-ee](https://nixos.org/nixos/packages.html?attr=graalvm11-ee&channel=nixpkgs-unstable&query=graalvm11-ee)

{% hint style="info" %}
This package will be installed only if `quarkus` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

### MacOS software

#### brew

* [openjdk](https://formulae.brew.sh/formula/openjdk)
* [maven](https://formulae.brew.sh/formula/maven)
* [maven-completion](https://formulae.brew.sh/formula/maven-completion)
* [maven-shell](https://formulae.brew.sh/formula/maven-shell)
* [gradle](https://formulae.brew.sh/formula/gradle)
* [gradle-completion](https://formulae.brew.sh/formula/gradle-completion)
* [jetty](https://formulae.brew.sh/formula/jetty)

{% hint style="info" %}
This package will be installed only if `jetty` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

* [tomcat](https://formulae.brew.sh/formula/tomcat)

{% hint style="info" %}
This package will be installed only if `tomcat` is enabled in your [vscode-anywhere.sls](../../structure/conf/saltstack/pillar.md#vscode-anywhere-sls) file.
{% endhint %}

## Documentation

* [Java\_SE14](https://github.com/Kapeli/feeds/blob/master/Java_SE14.xml)

## VSCode-Anywhere

### Environment

#### Windows environment

```yaml
PATH: C:\VSCode-Anywhere\apps\scoop\apps\openjdk\current\bin;C:\VSCode-Anywhere\apps\scoop\apps\maven\current\bin
JAVA_HOME: C:\VSCode-Anywhere\apps\scoop\apps\openjdk\current
JDK_HOME: C:\VSCode-Anywhere\apps\scoop\apps\openjdk\current
```

{% hint style="info" %}
If `quarkus` is enabled, the following `PATH` will be append:

```yaml
C:\VSCode-Anywhere\apps\scoop\apps\graalvm\current\bin
```
{% endhint %}

If `jetty` is enabled the following envrionment will be set:

```yaml
JETTY_HOME: C:\SCode-Anywhere\apps\scoop\apps\Chocolatey\lib\jetty\tools\jetty
```

{% hint style="info" %}
Assuming you have installed in the default directory `C:\VSCode-Anywhere`.
{% endhint %}

#### Linux environment

```yaml
PATH: /home/linuxbrew/.linuxbrew/opt/openjdk/bin
JAVA_HOME: /home/linuxbrew/.linuxbrew/opt/openjdk/libexec
JDK_HOME: /home/linuxbrew/.linuxbrew/opt/openjdk/libexec
```

If `tomcat` is enabled the following envrionment will be set:

```yaml
CATALINA_BASE: /home/linuxbrew/.linuxbrew/opt/tomcat/libexec
CATALINA_HOME: /home/linuxbrew/.linuxbrew/opt/tomcat/libexec
```

If `jetty` is enabled the following envrionment will be set:

```yaml
JETTY_HOME: /home/linuxbrew/.linuxbrew/opt/jetty/libexec
```

#### MacOS environment

```yaml
PATH: /home/linuxbrew/.linuxbrew/opt/openjdk/bin
JAVA_HOME: /home/linuxbrew/.linuxbrew/opt/openjdk/libexec
JDK_HOME: /home/linuxbrew/.linuxbrew/opt/openjdk/libexec
```

If `tomcat` is enabled the following envrionment will be set:

```yaml
CATALINA_BASE: /home/linuxbrew/.linuxbrew/opt/tomcat/libexec
CATALINA_HOME: /home/linuxbrew/.linuxbrew/opt/tomcat/libexec
```

If `jetty` is enabled the following envrionment will be set:

```yaml
JETTY_HOME: /home/linuxbrew/.linuxbrew/opt/jetty/libexec
```

### Specific settings

#### spring\_boot

If set to `True`, it will install additional components for [Spring Boot](https://spring.io/projects/spring-boot):

```yaml
vscode-anywhere:
    java:
        enabled: True
        spring_boot: True
```

#### quarkus

If set to `True`, it will install additional components for [Quarkus](https://quarkus.io/):

```yaml
vscode-anywhere:
    java:
        enabled: True
        quarkus: True
```

#### tomcat

If set to `True`, it will install additional components for [Tomcat](https://tomcat.apache.org/):

```yaml
vscode-anwyhere:
    java:
        enabled: True
        tomcat: True
```

#### jetty

If set to `True`, it will install additional components for [Jetty](https://www.eclipse.org/jetty/):

```yaml
vscode-anwyhere:
    java:
        enabled: True
        jetty: True
```


.. _module_ruby:

====
Ruby
====

.. image:: https://upload.wikimedia.org/wikipedia/commons/7/73/Ruby_logo.svg
    :alt: Ruby
    :height: 250px

About
#####

`Ruby <https://www.ruby-lang.org>`__ is an interpreted, high-level,
general-purpose programming language. It was designed and developed in the
mid-1990s by Yukihiro "Matz" Matsumoto in Japan.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

rebornix.Ruby
*************

This `extension <https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby>`__
provides enhanced Ruby language and debugging support for Visual Studio Code.

castwide.solargraph
*******************

`Solargraph <https://marketplace.visualstudio.com/items?itemName=castwide.solargraph>`__
is a language server that provides intellisense, code completion, and inline
documentation for Ruby.

.. image:: https://github.com/castwide/vscode-solargraph/raw/master/vscode-solargraph-0.34.1.gif
    :alt: Ruby IntelliSense

connorshea.vscode-ruby-test-adapter
***********************************

This `extension <https://marketplace.visualstudio.com/items?itemName=connorshea.vscode-ruby-test-adapter>`__
allow to run your Ruby tests.

.. image:: https://github.com/connorshea/vscode-ruby-test-adapter/raw/master/img/screenshot.png
    :alt: Ruby tests

kaiwood.endwise
***************

This `extension <https://marketplace.visualstudio.com/items?itemName=kaiwood.endwise>`__
allow to run your Ruby tests.

.. image:: https://github.com/kaiwood/vscode-endwise/raw/master/images/endwise.gif
    :alt: Endwise

bung87.rails
************

This `extension <https://marketplace.visualstudio.com/items?itemName=bung87.rails>`__
allow Ruby on Rails support in VSCode.

.. image:: https://github.com/bung87/vscode-rails/raw/master/images/vscode-rails.gif
    :alt: Rails

.. note::

    This exension will be installed only if ``rails`` is enabled.

shanehofstetter.rails-i18n
**************************

This `extension <https://marketplace.visualstudio.com/items?itemName=shanehofstetter.rails-i18n>`__
is a Rails i18n helper.

.. image:: https://github.com/shanehofstetter/rails-i18n-vscode/raw/master/docs/autocomplete.gif
    :alt: rails-i18n

.. note::

    This exension will be installed only if ``rails`` is enabled.

aki77.rails-routes
******************

This `extension <https://marketplace.visualstudio.com/items?itemName=aki77.rails-routes>`__
is a definition and completion provider for Rails Routes.

.. image:: https://i.gyazo.com/2478adce19549f877fcb7389bd7a1f9f.gif
    :alt: Rails routes

.. note::

    This exension will be installed only if ``rails`` is enabled.

jemmyw.rails-fast-nav
*********************

This `extension <https://marketplace.visualstudio.com/items?itemName=jemmyw.rails-fast-nav>`__
allow Navigation in Rails.

.. image:: https://github.com/jemmyw/vscode-rails-fast-nav/raw/master/images/railsnav.gif
    :alt: Rails navigation

.. note::

    This exension will be installed only if ``rails`` is enabled.

vortizhe.simple-ruby-erb
************************

This `extension <https://marketplace.visualstudio.com/items?itemName=vortizhe.simple-ruby-erb>`__
provides a simple Ruby and ERB language, code snippets and ERB tag helper
support for Visual Studio Code without messing with linting or debugging.

.. image:: https://raw.githubusercontent.com/vortizhe/vscode-ruby-erb/master/images/toggleTags.gif
    :alt: Ruby erb

.. note::

    This exension will be installed only if ``rails`` is enabled.

karunamurti.haml
****************

This `extension <https://marketplace.visualstudio.com/items?itemName=karunamurti.haml>`__
provides haml support, with parentheses coloring, auto close parentheses,
brackets, curly braces, quote, double quote, backtick, ruby interpolations,
etc.

.. image:: https://github.com/karuna/haml-vscode/raw/master/images/screenshot.png
    :alt: Ruby haml

.. note::

    This exension will be installed only if ``rails`` is enabled.

aki77.haml-lint
***************

This `extension <https://marketplace.visualstudio.com/items?itemName=aki77.haml-lint>`__
provides a haml linter.

.. note::

    This exension will be installed only if ``rails`` is enabled.

VSCode settings
###############

VSCode settings configuration for ``ruby``:

.. code-block:: json

    {
        "ruby.lint": [
            "reek": true,
            "rubocop": false,
            "ruby": true,
            "fasterer": true,
            "debride": true,
            "ruby-lint": true
        ],
        "ruby.codeCompletion": false,
        "ruby.format": false,
        "ruby.intellisense": false,
        "solargraph.autoformat": true,
        "solargraph.hover": true,
        "solargraph.completion": true,
        "solargraph.diagnostics": true,
        "solargraph.formatting": true
    }

Windows settings
****************

.. code-block:: json

    {
        "ruby.interpreter.commandPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\ruby\\current\\bin\\gem.cmd",
        "solargraph.commandPath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\ruby\\current\\gems\\bin\\solargraph.cmd"
    }

If ``rails`` is set to ``True``:

.. code-block:: json

    {
        "hamlLint.executablePath": "C:\\VSCode-Anywhere\\apps\\scoop\\apps\\ruby\\current\\gems\\bin\\haml-lint.bat"
    }

.. note::

    Assuming you have installed in the default directory ``C:\VSCode-Anywhere``.

Software
########

Windows software
****************

scoop
=====

- `ruby <https://github.com/ScoopInstaller/Main/blob/master/bucket/ruby.json>`__

.. note::

    ``ridk install 3`` will be executed after installing ruby.

    ``ridk`` will install all dependencies for compiling ruby modules.

Docsets
#######

2 docsets will be installed:

- `Ruby <https://github.com/Kapeli/feeds/blob/master/Ruby.xml>`__
- `Ruby_2 <https://github.com/hashhar/dash-contrib-docset-feeds/blob/master/Ruby_2.xml>`__

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    ruby:
        enabled: True

Environment
***********

Windows environment
*******************

.. code-block:: yaml+jinja

    ruby:
        env:
            GEM_HOME: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'ruby', 'current', 'gems') }}
            GEM_PATH: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'ruby', 'current', 'gems') }}
            PATH: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'ruby', 'current', 'gems', 'bin') }};{{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'ruby', 'current', 'bin') }}

Specific module settings
************************

rails
=====

If set to ``True``, it will install additional components for
`Ruby On Rails <https://rubyonrails.org>`_:

.. code-block:: yaml

    ruby:
        enabled: True
        rails: True

gem
===

`gem <https://rubygems.org>`_ is used to install some Python packages.

The following python packages will be installed:

- `rdoc <https://rubygems.org/gems/rdoc>`_
- `fastri <https://rubygems.org/gems/fastri>`_
- `pkg-config <https://rubygems.org/gems/pkg-config>`_
- `nokogiri <https://rubygems.org/gems/nokogiri>`_
- `rubygems-update <https://rubygems.org/gems/rubygems-update>`_
- `ruby-debug-ide <https://rubygems.org/gems/ruby-debug-ide>`_
- `rcodetools <https://rubygems.org/gems/rcodetools>`_
- `reek <https://rubygems.org/gems/reek>`_
- `fasterer <https://rubygems.org/gems/fasterer>`_
- `debride <https://rubygems.org/gems/debride>`_
- `ruby-lint <https://rubygems.org/gems/ruby-lint>`_
- `solargraph <https://rubygems.org/gems/solargraph>`_

If ``rails`` is set to ``True`` then the following packages will also be
installed:

- `haml_lint <https://rubygems.org/gems/haml_lint>`_

.. code-block:: yaml

    ruby:
        enabled: True
        gem:
            pkgs:
                rdoc:
                    enabled: True
                fastri:
                    enabled: True
                pkg-config:
                    enabled: True
                nokogiri:
                    enabled: True
                rubygems-update:
                    enabled: True
                ruby-debug-ide:
                    enabled: True
                rcodetools:
                    enabled: True
                reek:
                    enabled: True
                fasterer:
                    enabled: True
                debride:
                    enabled: True
                ruby-lint:
                    enabled: True
                solargraph:
                    enabled: True
                haml_lint:
                    enabled: True

You can use advanced gem options:

.. code-block:: yaml+jinja

    ruby:
        enabled: True
        gem:
            opts:
                global:
                    gem_bin: {{ salt['grains.get']('vscode-anywhere:apps:path') | path_join('scoop', 'apps', 'ruby', 'current', 'bin', 'gem.cmd') }}
                install:
                    rdoc: True
                    ri: True
                update:
                    rdoc: True
                    ri: True
                uninstall: {}
            pkgs:
                solargraph:
                    enabled: True
                    version: '0.38.0'
                    opts:
                        install: {}
                        update: {}
                        uninstall: {}

GEM options:

- ``gem.opts.global``: `gem options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.gem.html>`__
    used to install, update and delete a gem module
- ``gem.opts.install``: `gem.installed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.gem.html#salt.states.gem.installed>`__
    used to install a gem module
- ``gem.opts.update``: `gem.installed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.gem.html#salt.states.gem.installed>`__
    is used to update a gem module
- ``gem.opts.uninstall``: `gem.removed options <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.gem.html#salt.states.gem.removed>`__
    used to delete a gem module
- ``gem.pkgs.<module_name>.opts.install``: same thing as ``gem.opts.install``
  but only apply for the target module
- ``gem.pkgs.<module_name>.opts.update``: same thing as ``gem.opts.update``
  but only apply for the target module
- ``gem.pkgs.<module_name>.opts.uninstall``: same thing as
  ``gem.opts.uninstall`` but only apply for the target module
- ``gem.pkgs.<module_name>.version``: specify the version to install
- ``gem.pkgs.<module_name>.enabled``: specify if the target module must be
  installed

.. note::

    Also, don't add the ``name`` option because it is already set!

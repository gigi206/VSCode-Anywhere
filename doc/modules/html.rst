.. _module_html:

===============================
HTML / CSS / Sass / Less /Emmet
===============================

.. image:: https://upload.wikimedia.org/wikipedia/commons/6/61/HTML5_logo_and_wordmark.svg
    :alt: HTML
    :height: 250px

About
#####

`Hypertext Markup Language <https://html.spec.whatwg.org/>`_ (HTML) is the standard markup
language for documents designed to be displayed in a web browser.
It can be assisted by technologies such as Cascading Style Sheets
CSS and scripting languages such as :ref:`JavaScript <module_javascript>`.

Prerequisites
#############

No prerequisites required.

VSCode extensions
#################

For more details, read the the official documentation `HTML <https://code.visualstudio.com/docs/languages/html>`__
and `CSS / SCSS / Less <https://code.visualstudio.com/docs/languages/css>`_.

VSCode includes a native support of `emmet <https://code.visualstudio.com/docs/editor/emmet>`__.

ecmel.vscode-html-css
*********************

`This extension <https://marketplace.visualstudio.com/items?itemName=ecmel.vscode-html-css>`__
adds CSS support for HTML documents.

Zignd.html-css-class-completion
*******************************

`This extension <https://marketplace.visualstudio.com/items?itemName=Zignd.html-css-class-completion>`__
that provides CSS class name completion for the HTML class attribute based on
the definitions found in your workspace for external files referenced through
the link element.

.. image:: https://i.imgur.com/5crMfTj.gif
    :alt: CSS IntelliSense

pranaygp.vscode-css-peek
************************

`This extension <https://marketplace.visualstudio.com/items?itemName=pranaygp.vscode-css-peek>`__
extends HTML and ejs code editing with Go To Definition and Go To Symbol
in Workspace support for css/scss/less (classes and IDs) found in strings
within the source code.

.. image:: https://github.com/pranaygp/vscode-css-peek/raw/master/working.gif
    :alt: CSS peek

bradgashler.htmltagwrap
***********************

`This extension <https://marketplace.visualstudio.com/items?itemName=bradgashler.htmltagwrap>`__
allow to wrap your selection in HTML tags. Can wrap inline selections and
selections that span multiple lines (works with both single selections and
multiple selections at once).

.. image:: https://github.com/bgashler1/vscode-htmltagwrap/raw/master/images/screenshot.gif
    :alt: HTML wrap

Umoxfo.vscode-w3cvalidation
***************************

`This extension <https://marketplace.visualstudio.com/items?itemName=Umoxfo.vscode-w3cvalidation>`__
enable W3C validation support by the `Nu Html Checker library <https://validator.github.io/validator/>`_.

Extension highlights wrong properties and values when enabled. Just install
the extension and open your CSS file. Validation will be performing in
background.

vincaslt.highlight-matching-tag
*******************************

`This extension <https://marketplace.visualstudio.com/items?itemName=vincaslt.highlight-matching-tag>`__
is intended to provide the missing functionality that should be built-in out
of the box in VSCode - to highlight matching opening or closing tags.

.. image:: https://images2.imgbox.com/71/2a/zIA1XCzK_o.gif
    :alt: Highlight Matching Tag

formulahendry.auto-rename-tag
*****************************

`This extension <https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag>`__
Automatically rename paired HTML/XML tag.

.. image:: https://github.com/formulahendry/vscode-auto-rename-tag/raw/master/images/usage.gif
    :alt: Auto Rename Tag

mrmlnc.vscode-autoprefixer
**************************

`This extension <https://marketplace.visualstudio.com/items?itemName=mrmlnc.vscode-autoprefixer>`__
provides an interface to `autoprefixer <https://github.com/postcss/autoprefixer>`_.

.. image:: https://cloud.githubusercontent.com/assets/7034281/16823311/da82a3c6-496b-11e6-8d95-0bebbf0b9607.gif
    :alt: Autoprefixer

esbenp.prettier-vscode
**********************

`Prettier <https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode>`_
is an opinionated code formatter. It enforces a consistent style by parsing
your code and re-printing it with its own rules that take the maximum line
length into account, wrapping code when necessary.

naumovs.color-highlight
***********************

`This extension <https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight>`__
styles css/web colors found in your document.

.. image:: https://naumovs.gallerycdn.vsassets.io/extensions/naumovs/color-highlight/2.3.0/1499789961213/Microsoft.VisualStudio.Services.Icons.Default
    :alt: Color Highlight

smelukov.vscode-csstree
***********************

`CSSTree validator <https://marketplace.visualstudio.com/items?itemName=smelukov.vscode-csstree>`__
validates CSS according to W3C specs and browser implementations.

.. image:: https://cloud.githubusercontent.com/assets/6654581/18788246/d0d4c7ca-81ae-11e6-9777-36806fd4cbfb.png
    :alt: CSSTree validator

.. codemooseus.vscode-devtools-for-chrome
.. **************************************

.. `This extension <https://marketplace.visualstudio.com/items?itemName=codemooseus.vscode-devtools-for-chrome>`__
.. to host the chrome devtools inside of a webview.

.. .. image:: https://github.com/CodeMooseUS/vscode-devtools/raw/master/demo2.gif
..    :alt: Devtools for Chrome

.. auchenberg.vscode-browser-preview
.. *********************************

.. `This extension <https://marketplace.visualstudio.com/items?itemName=codemooseus.vscode-devtools-for-chrome>`__
.. is a real browser preview inside your editor that you can debug

.. .. image:: https://github.com/auchenberg/vscode-browser-preview/raw/master/resources/demo.gif
..    :alt: Browser preview

VSCode settings
###############

VSCode settings configuration for ``html``.

Global settings
***************

.. code-block:: json

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

Software
########

Windows software
****************

scoop
=====

- `openjdk <https://github.com/ScoopInstaller/Main/blob/master/bucket/python.json>`_
  (required by the extensions `Umoxfo.vscode-w3cvalidation`_).

Docsets
#######

4 docsets will be installed:

- `HTML <https://github.com/Kapeli/feeds/blob/master/HTML.xml>`__
- `CSS <https://github.com/Kapeli/feeds/blob/master/CSS.xml>`_
- `Emmet <https://github.com/Kapeli/feeds/blob/master/Emmet.xml>`__
- `Saas <https://github.com/Kapeli/feeds/blob/master/Sass.xml>`_
- `Less <https://github.com/Kapeli/feeds/blob/master/Less.xml>`_

https://github.com/Kapeli/feeds

VSCode-Anywhere
###############

Module installation
*******************

To enable this :ref:`module <modules>`:

.. code-block:: yaml

    html:
        enabled: True

Environment
***********

No environment.

Specific module settings
************************

No Specific settings.

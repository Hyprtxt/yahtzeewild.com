# Wild Yacht Dice

I made this for my mom!

* Animations Lifted from [Animate.css](https://daneden.github.io/animate.css/)
* Icons from [Font-Awesome](fortawesome.github.io/Font-Awesome/icons/)
* Random numbers from [Random JS](https://www.npmjs.com/package/random-js)
* Pretty Popups from [Vex](http://github.hubspot.com/vex/docs/welcome/)
* Views & Collections from [Backbone](http://backbonejs.org/)
* DOM manipulation with [jQuery](http://jquery.com/)

# Hypr Hapi

I can make the things with this, you too!

* Freedom of software
* The terminal is your friend
* Whitespace is king
* Automate all the things
* Source control, `git`
* `s/ftp` is something to be avoided

## Get Started

You'll need, some things for the stuff to work

* Node installed with NVM
* [Atom](https://atom.io/) - Text Editor
* [Nginx](https://www.nginx.com/) - Web Server
* [Chrome](https://www.google.com/chrome/) - Browser
  * The [LiveReload Extension](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei?hl=en) for Chrome
* iTerm2 - A Terminal

#### Install Bower and Gulp globally

`npm i -g bower gulp`

#### Install `node_modules` and `bower_components`

`npm install;bower install`

#### Fire it up!

`npm start` in Terminal #1
`gulp watch` in Terminal #2

### Install NVM

`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.28.0/install.sh | bash`

### Install Nginx

@todo For OSX and Ubuntu?

# Front End

## Configuration

`./view-data/global.coffee` is passed to all Jade templates. Use it for global front-end configuration values.

# Node Package Manager

Well, you're here after all, so I'd guess you already know why `npm` is so great. What follows is a an explanation of the major packages in use by Hyprtxt.

# Bower

Bower is used to manage OP's (other peoples) client side code.

* jQuery
* Bootstrap
* Font Awesome

## Gulp

[Gulp](http://gulpjs.com/) is a task runner that enables awesome like:

* Automated moving of the things (copies files for us, enables Bower)
* SASS (Source Mapping, AutoPrefixing)
* CoffeeScript (Source Mapping)
* Jade (HAPI or Static)
* LiveReload (Via Chrome Extension)
* Static website building

Files in the `./src` directory are compiled and output to the `./static_generated` directory

### SASS

Okay this one is technically a Ruby module. Used for CSS.

### Coffee Script

Coffee Script is at the very heart of this project.

### Jade

The HTML template language

## Hapi

[Hapi](http://hapijs.com/) is a collection of modules that form the foundation of this application.

Files in the `./static` & `./static_generated` directory are served up as-is by Hapi

In addition to the core modules, serveral other Hapi modules are used by this project:

* Vision - view rendering
* Good - logging
* Boom - errors
* Confidence - configuration
* Inert - static file serving

# Forever Startup

```
forever start --uid "yahtzeewild.com" --append -c ./node_modules/coffee-script/bin/coffee index.coffee
```

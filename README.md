# Paradiso

An adapter-based framework for building isomorphic applications.

## Features

Switch out underlying libraries without changing application code.

Build resuable component, framework, and server adapters that operate transparently.

Plugins for `Express`, `Mithril`, `Browserify`, `Coffeeify`, `Envify`, `Uglify`, and more.

## Install

```bash
npm install -g paradiso
```

## Getting started

First, let's create a very simple project with the following structure:

    app/
      components/
        home.coffee
      initializers/
        build.coffee
        client.coffee
        routes.coffee
        server.coffee

(**Protip**: Feel free to organize your files how you like. Paradiso is unopinionated.)

### Initializers

The `app/initializers` directory includes:
 
* `build.coffee` - builds the client asset
* `client.coffee` - defines the client asset
* `routes.coffee` - contains routes for client and server
* `server.coffee` - starts the web server

#### Build initializer

`app/initializers/build.coffee`:

```coffee
build      = require "paradiso-build"
browserify = require "paradiso-build-browserify"
coffeeify  = require "paradiso-build-coffeeify"

browserify
  paths:
    "public/client": "app/initializers/client"

build browserify, coffeeify
```

#### Client initializer

`app/initializers/client.coffee`:

```coffee
require "./routes"

client = require "paradiso-client"
client()
```

#### Route initializer

`app/initializers/routes.coffee`:

```coffee
routes = require "paradiso-routes"

routes map:
  "/": require "../components/home.coffee"
```

#### Server initializer

`app/initializers/server.coffee`: 

```coffee
server  = require "paradiso-server"
express = require "paradiso-server-express"
routes  = require "./routes"

server express, routes,
  port:   9000
  static: "public"
```

### Component

`components/home.coffee`:

```coffee
module.exports = -> "hello!"
```

### Build assets

Build your client js assets:

```bash
coffee app/initializers/build.coffee
```

or with `gulp`:

```coffee
gulp     = require "gulp"
paradiso = require "paradiso"

gulp.task "build", -> require "app/initializers/build"
```

### Start server

Start the web server:

```bash
coffee app/initializers/server.coffee
```

or with `gulp`:

```coffee
gulp     = require "gulp"
paradiso = require "paradiso"

gulp.task "server", -> require "app/initializers/server"
```

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

This project is available in the [getting-started](https://github.com/invrs/paradiso-example/tree/getting-started) branch of the example repo.

### Components

Paradiso ships with [paradiso-component](https://github.com/invrs/paradiso-component), an object oriented approach to writing components.

#### Initializers

Add component functionality through the initializers:

`app/initializers/client.coffee`:

```coffee
require "./routes"

client    = require "paradiso-client"
component = require "paradiso-component"
mithril   = require "paradiso-component-mithril"

client component, mithril
```

`app/initializers/server.coffee`:

```coffee
require "./routes"

server    = require "paradiso-server"
express   = require "paradiso-server-express"
component = require "paradiso-component"
mithril   = require "paradiso-component-mithril"

server component, express, mithril,
  port:   9000
  static: "public"
```

#### Component

Let's build a valid HTML page with content:

`components/home.coffee`:

```coffee
module.exports = class

  constructor: ->
    @title   = "Home"
    @content = [
      @H1 @title
      @P  if @server "server" else "client"
    ]

  view: ->
    if @server
      @layoutView @
    else
      @content
  
  LayoutView: class
    constructor: ({ @content, @title }) ->

    view: ->
      @HTML [
        @HEAD @title
        @BODY @content
      ]
```

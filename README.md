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
        home/
          route.coffee
      initializers/
        build.coffee
        client.coffee
        routes.coffee
        server.coffee

(**Protip**: Feel free to organize your files how you like. Paradiso is unopinionated.)

### Initializers

The `app/initializers` directory includes:
 
* `build.coffee` - build client asset
* `client.coffee` - define client asset
* `routes.coffee` - routes for client and server
* `server.coffee` - web server

#### Build initializer

`app/initializers/build.coffee`:

```coffee
build      = require "paradiso-build"
browserify = require "paradiso-build-browserify"
coffeeify  = require "paradiso-build-coffeeify"

browserify
  paths:
    "public/client": "app/initializers/client"

module.exports = build browserify, coffeeify
```

#### Client initializer

`app/initializers/client.coffee`:

```coffee
client = require "paradiso-client"
routes = require "./routes"

module.exports = client routes
```

#### Route initializer

`app/initializers/routes.coffee`:

```coffee
routes = require "paradiso-routes"

module.exports = routes
  map:
    "/": require "../components/home/route.coffee"
```

#### Server initializer

`app/initializers/server.coffee`: 

```coffee
server  = require "paradiso-server"
express = require "paradiso-server-express"
routes  = require "./routes"

module.exports = server express, routes,
  port:   9000
  static: "public"
```

### Component

`components/home/route.coffee`:

```coffee
module.exports = -> "hello!"
```

### Build assets

Build your client js assets:

```bash
paradiso app/initializers/build
```

or with `gulp`:

```coffee
gulp     = require "gulp"
paradiso = require "paradiso"

gulp.task "build", -> paradiso "app/initializers/build"
```

### Start server

Start the web server:

```bash
paradiso app/initializers/server
```

or with `gulp`:

```coffee
gulp     = require "gulp"
paradiso = require "paradiso"

gulp.task "server", -> paradiso "app/initializers/server"
```

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

This project is available in the [getting-started branch](https://github.com/invrs/paradiso-example/tree/getting-started) of the [paradiso-example](https://github.com/invrs/paradiso-example) repo.

### Components

Paradiso ships with [paradiso-component](https://github.com/invrs/paradiso-component), an object oriented approach to writing components.

#### Initializers

Add functionality to the initializers.

`app/initializers/client.coffee`:

```coffee
client    = require "paradiso-client"
component = require "paradiso-component"
routes    = require "./routes"

module.exports = client component, mithril, routes
```

`app/initializers/server.coffee`:

```coffee
server    = require "paradiso-server"
express   = require "paradiso-server-express"
mithril   = require "paradiso-component"
routes    = require "./routes"

module.exports = server component, express, mithril, routes,
  port:   9000
  static: "public"
```

#

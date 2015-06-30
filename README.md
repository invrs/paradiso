# Paradiso

An adapter-based way to write isomorphic applications. Change frameworks like what.

## Features

Adapters for all pieces of your isomorphic stack (components, DOM rendering, and web servers).

Provides a default component style that aims to be more traditionally object-oriented and extendable.

Support for `express`, `mithril`, and `react` out of the box.

## Getting started

Let's create the following directory structure:

    app/
      components/
        home/
          route.coffee
      initializers/
        build.coffee
        client.coffee
        routes.coffee
        server.coffee

(**Protip**: Feel free to name your files how you like; Paradiso is unopinionated.)

### Initializers

The `app/initializers` directory includes:
 
* `build.coffee` - configure the js asset build
* `client.coffee` - configure the client js asset
* `routes.coffee` - define routes for client and server
* `server.coffee` - configure the web server

#### Build initializer

`app/initializers/build.coffee`:

```coffee
Paradiso   = require "paradiso"
browserify = require "paradiso-build-browserify"
coffeeify  = require "paradiso-build-coffeeify"
envify     = require "paradiso-build-envify"
uglify     = require "paradiso-build-uglify"
routes     = require "./routes"

module.exports = ->
  build = [ coffeeify, envify, browserify, uglify ]

  new Paradiso({ build }).build
    "./public": "./app/initializers/client"
```

(**Protip**: You can have multiple client assets, just use an array of filenames.)

#### Client initializer

`app/initializers/client.coffee`:

```coffee
Paradiso  = require "paradiso"
component = require "paradiso-component"
render    = require "paradiso-render-mithril"
routes    = require "./routes"

module.exports = ->
  new Paradiso({ component, render, routes }).client()
```

#### Route initializer

`app/initializers/routes.coffee`:

```coffee
module.exports = ->
  "/": require "../components/home/route.coffee"
```

#### Server initializer

`app/initializers/server.coffee`: 

```coffee
Paradiso = require "paradiso"
render   = require "paradiso-render-mithril"
server   = require "paradiso-server-express"
routes   = require "./routes"

module.exports = ->
  server = new Paradiso({ component, render, routes, server }).server()

  # Express-specific code
  #
  server.then ({ app, lib }) ->

    app.use lib.static "public"

    app.listen 9000, ->
      console.log "Server started at http://127.0.0.1:9000"
```

### Adapters

You may be wondering, "What are these `paradiso-` libraries? Why are they separate?"

Paradiso composes your stack using adapters, meaning you can easily change your build, rendering engine, server, or component style at any time.

Later we will discuss writing and modifying adapters, but for now let's stick to building the app.

### Components

Here is the simplest way to define a component using the `paradiso-component` adapter style:

`components/home/route.coffee`:

```coffee
module.exports = class

  view: -> "hello!"
```

### Build assets

Now your project should resemble [step 1 of the example project](https://github.com/invrs/paradiso-example/tree/step-1).

Run your build initializer to build the client js asset:

```bash
coffee -e "require('./app/initializers/build')()"
```

Or use gulp:

```coffee
gulp  = require "gulp"
build = require "./app/initializers/build"

gulp.task "build", -> build()
```

### Start server

```bash
coffee -e "require('./app/initializers/server')()"
```

Or use gulp:

```coffee
gulp  = require "gulp"
build = require "./app/initializers/server"

gulp.task "server", -> server()
```

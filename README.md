# Paradiso

Adapter-based isomorphic applications. Change frameworks like what.

## Features

Adapters for all parts of your isomorphic stack (components, builds, rendering, web servers).

Provides a default component style that aims to be more traditionally object-oriented and extendable.

Build your own component and framework adapters that operate transparently.

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

(**Protip**: Feel free to name your files how you like. Paradiso is un-opinionated.)

### Initializers

The `app/initializers` directory includes:
 
* `build.coffee` - configure the client js asset build
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
Paradiso  = require "paradiso"
component = require "paradiso-component"
render    = require "paradiso-render-mithril"
server    = require "paradiso-server-express"
routes    = require "./routes"

module.exports = ->
  server = new Paradiso({ component, render, routes, server }).server()

  # Express-specific code
  #
  # @param app the express instance
  # @param lib the express library
  #
  server.then ({ app, lib }) ->

    app.use lib.static "public"

    app.listen 9000, ->
      console.log "Server started at http://127.0.0.1:9000"
```

### Home route component

Components defined in your routes file must have a `view` function.

`components/home/route.coffee`:

```coffee
module.exports = class

  view: ->
    if @server
      @HTML @BODY "hello!"
    else
      "hello!"
```

(**Protip**: Use the `@server` variable to know if you are rendering server or client side.)

### Build assets

Run your build initializer to build the client js assets:

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

Run your server initializer to start express:

```bash
coffee -e "require('./app/initializers/server')()"
```

Or use gulp:

```coffee
gulp   = require "gulp"
server = require "./app/initializers/server"

gulp.task "server", -> server()
```

### That's it

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

This example is available in the [getting-started branch](https://github.com/invrs/paradiso-example/tree/getting-started) of the `paradiso-example` project.

Let's learn more about components so we can do some cool isomorphic stuff.

## View components

Mithril introduces the concept of a [view-model](http://lhorie.github.io/mithril-blog/what-is-a-view-model.html), a component that keeps view logic separate from stateful operations.

Here is how we define a route that uses a separate view component (view-model) using Paradiso:

`app/components/home.route.coffee`:

```coffee
module.exports = class

  @HomeView: require "./home.view"

  constructor: ->
    @body = "hello!"

  view: ->
    # Creates a new instance of `HomeView` and calls `view({ body })`
    # on it.
    #
    @homeView { @body }
```

`app/components/home.view.coffee`:

```coffee
module.exports = class

  constructor: ({ @body }) ->

  view: ->
    if @server
      @HTML @BODY @body
    else
      @body
```

### Example

This example is available in the [view-component branch](https://github.com/invrs/paradiso-example/tree/view-component) of the `paradiso-example` project.

## Extending components

Let's add the `@a` ([mithril-ajax](https://github.com/invrs/mithril-ajax)) and `@r` ([mithril-redraw](https://github.com/invrs/mithril-redraw)) extensions to our component structure.

`app/initializers/client.coffee`:

```coffee
Paradiso = require "paradiso"
render   = require "paradiso-render-mithril"
routes   = require "./routes"

component = [
  require "paradiso-component"
  require "paradiso-component-mithril-ajax"
  require "paradiso-component-mithril-redraw"
]

module.exports = ->
  new Paradiso({ component, render, routes }).client()
```

Don't forget to extend your component structure in `app/initializers/server.coffee` as well.

## Component diagram

If you're still scratching your head about helpers, state, and where component extensions come in:

[![Component diagram](https://www.gliffy.com/go/publish/image/8457893/L.png)](https://www.gliffy.com/go/publish/image/8457893/L.png)

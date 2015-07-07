# Paradiso

An adapter-based framework for building isomorphic applications.

## Features

Switch out underlying libraries without changing application code.

Build resuable component, framework, and server adapters that operate transparently.

Plugins for Express, Mithril, Browserify, Coffeeify, Envify, Uglify, and more.

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
  "/": require "../components/home/route.coffee"
```

#### Server initializer

`app/initializers/server.coffee`: 

```coffee
server  = require "paradiso-server"
express = require "paradiso-server-express"
routes  = require "./routes"

server express, routes
server
  use: 

# Configure express.
#
server ->
  @app.use @lib.static "public"

  @app.listen 9000, ->
    console.log "Server started at http://127.0.0.1:9000"

module.exports = server  
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

Build your client js assets:

```bash
paradiso app/initializers/build
```

### Start server

Start express:

```bash
paradiso app/initializers/server
```

### That's it

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

This example is available in the [getting-started branch](https://github.com/invrs/paradiso-example/tree/getting-started) of the `paradiso-example` project.

Let's learn more about components so we can do some cool isomorphic stuff.

## Component creation helpers

Paradiso provides helpers for succinct creation and updating of components:

```coffee
module.exports = class

  BodyView: require "./body.view"
  Content:  require "./content"

  constructor: ->
    @bodyView()  # new BodyView().view()
    @content()   # content = new Content()

    @bodyView()  # new BodyView().view()
    @content()   # content

    @content(x: true)  # content.x = true
                       # content
```

If the component name ends in `View`, the helper function creates a new instance of the component every time and automatically calls `view()`.

If the class does not end in `View`, the helper function creates the component and saves it. Subsequent calls to the helper function return the saved component instance.

## View components

Why the different behaviour for `View` components?

Mithril introduced the concept of a [view-model](http://lhorie.github.io/mithril-blog/what-is-a-view-model.html), a component that keeps view logic separate from stateful operations.

Here is how we define a route with a view component (view-model):

`app/components/home.route.coffee`:

```coffee
module.exports = class

  HomeView: require "./home.view"

  constructor: ->
    @body = "hello!"

  view: ->
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

If you're still scratching your head about routes, helpers, state, and where component extensions come in, maybe this will help:

[![Component diagram](https://www.gliffy.com/go/publish/image/8457893/L.png)](https://www.gliffy.com/go/publish/image/8457893/L.png)

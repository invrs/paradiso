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

(**Protip**: Feel free to name your files how you like; Paradiso is un-opinionated.)

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

### Home route component

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

Now your project should resemble [step one of the example project](https://github.com/invrs/paradiso-example/tree/step-1).

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

Run your server initializer to start express:

```bash
coffee -e "require('./app/initializers/server')()"
```

Or use gulp:

```coffee
gulp  = require "gulp"
build = require "./app/initializers/server"

gulp.task "server", -> server()
```

### That's it

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

Let's learn more about components so we can do some cool isomorphic stuff.

## Components (continued)

### Views

As you saw in [step one](https://github.com/invrs/paradiso-example/tree/step-1), we defined a `view` function to describe what is rendered on the page.

Mithril introduces the concept of a [view-model](http://lhorie.github.io/mithril-blog/what-is-a-view-model.html), which is essentially a component that doesn't hold state and only contains view logic. View components only exist for the lifetime of the redraw.

Here is how we define a route that uses a separate view component using Paradiso:

`app/components/home.route.coffee`:

```coffee
module.exports = class

  @HomeView: require "./home.view"

  constructor: ->
    @body = "hello!"

  view: ->
    new @HomeView(@).view()
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

#### Uni-directional data flow

In this example you can see how we pass parameters down the chain from component to component.

We've found that its easiest to pass `@` to the component constructor and then use destructuring assignment to pick which variables we want. However, its totally up to you how you pass data to your constructors.

#### View helpers

Paradiso generates helper methods to create and execute new view components.

`app/components/home.route.coffee`:

```coffee
module.exports = class

  @HomeView: require "./home.view"

  constructor: ->
    @body = "hello!"

  view: ->
    @homeView @
```

Instead of writing `new @HomeView(@).view()`, we can simplify it to `@homeView @`.

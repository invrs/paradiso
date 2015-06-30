# Paradiso

An adapter-based way to write isomorphic applications. Change frameworks like what.

## Features

Adapters for all pieces of your isomorphic stack (components, DOM rendering, and web servers).

Provides a default component style that aims to be more traditionally object-oriented and extendable.

Support for `express`, `mithril`, and `react` out of the box.

## Structure

To start, we will create the following directory structure:

    app/
      components/home/
        route.coffee
      initializers/
        client.coffee
        routes.coffee
        server.coffee

Paradiso does not prescribe a specific file or directory naming pattern. This is just a suggestion.

### Initializers

The `app/initializers` directory includes:
 
* A file for each client js asset (`client.coffee`)
* A file to define routes for client and server (`routes.coffee`)
* A file that boots the web server (`server.coffee`)

#### Route initializer

`app/initializers/routes.coffee`:

```coffee
module.exports =
  "/": require "../components/home/route.coffee"
```

#### Client initializer

`app/initializers/client.coffee`:

```coffee
Paradiso  = require "paradiso"
component = require "paradiso-component"
render    = require "paradiso-render-mithril"
routes    = require "./routes"

new Paradiso({ component, render, routes })
```

#### Server initializer

`app/initializers/server.coffee`: 

```coffee
Paradiso = require "paradiso"
render   = require "paradiso-render-mithril"
routes   = require "./routes"
server   = require "paradiso-server-express"

iso = new Paradiso({ component, render, routes, server })

# Express-specific code
#
app = iso.express.app
exp = iso.express.lib

app.use exp.static "dist"

app.listen 9000, ->
  console.log "Server started at http://127.0.0.1:9000"
```

### Adapters

You may be wondering, "What are `paradiso-component`, `paradiso-server-express`, and `paradiso-render-mithril`? Why are they separate libraries?"

Paradiso composes your stack using adapters, meaning you can easily switch your rendering engine, server, or component style at any time.

Later we will discuss writing and modifying adapters, but for now let's stick to building the app.

### Components

Here is the simplest way to define a component using `paradiso-component`:

`components/home/route.coffee`:

```coffee
module.exports = class

  view: -> "hello!"
```

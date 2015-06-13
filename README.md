# Paradiso

Thin layer to run isomorphic apps on any javascript client or server framework.

## Features

Defines a common way of defining reactive routes and components.

Build apps that render statically on the first request, then turn dynamic.

Switch rendering and routing engines in one line of code.

Easy to write adapters for your favorite framework.

## Adapters

### Web server

* express

### Isomorphic rendering and client routing

* mithril
* react

## Routes

    module.exports =
      "/": require "./components/home"

## Components

Create `components/home.coffee`:

    module.exports = class
      constructor: ->
        @title = "hello"

      view: ->
        @v View

      View: class
        constructor: ({ @title } = { title }) ->
        view: HTML HEAD @title

## Client

Create `client.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      # Uncomment one:
      #
      # mithril: require "mithril"
      # react:   require "react"
    .routes require "./routes"

## Server

Create `server.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      # Web server
      #
      express: require "express"

      # Framework Uncomment one:
      #
      # mithril: require "mithril"
      # react:   require "react"
    .routes require "./routes"

## Boot the server

You now have `client.coffee`, `server.coffee`, and `component/home.coffee`.

Start the server:

    coffee server.coffee

## Adapter example

    Paradiso = require "paradiso"

    Paradiso.adapters.basic = class
      constructor: (Klass, @server) -> @klass = new Klass(@server)
      view:                         -> @klass.view.apply(@, arguments)

    new Paradiso().routes
      "/": class view: "hello"

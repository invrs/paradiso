# Paradiso

A common way to write reactive and isomorphic apps on any js framework.

## Features

Provides a standard style for defining components and routes.

Change rendering and routing engines in one line of code.

Easy to write adapters for your favorite framework.

## Adapters

#### Rendering and routing

* mithril
* react

#### Web server

* express

## Components

Create `components/home.coffee`:

    module.exports = class
      constructor: ->
        @title = "title"

      view: ->
        @v @View

      View: class
        constructor: ({ @title }) ->

        header: -> H1 @title
        
        view:
          if @server
            HTML [
              HEAD TITLE @title
              BODY @header()
            ]
          else
            @header()

#### Component basics

* Components typically have a `view` function
* The `@params` variable is always present and holds route parameters
* The `@server` variable is present when executing server side
* Use the `@v` helper to instantiate and render stateless view classes
* Use the `@c` helper to instantiate stateful components
* Use the `@r` helper to manually render

## Routes

Create `routes.coffee`:

    module.exports =
      "/": require "./components/home"

## Client

Create `client.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      # Framework (uncomment one):
      #
      # mithril: require "mithril"
      # react:   require "react"

    .routes require "./routes"

## Server

Create `server.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      # Web server:
      #
      express: require "express"

      # Framework (uncomment one):
      #
      # mithril: require "mithril"
      # react:   require "react"

    .routes require "./routes"

## Start the server

You should now have the following files:

* `component/home.coffee`
* `routes.coffee`
* `client.coffee`
* `server.coffee`

Now start the server:

    coffee server.coffee

## Converting your project

Paradiso allows you to mix and match between common and framework-specific component styles while you convert your project.

Just specify the style in the route:

    module.exports =
      "/": mithril: require "./components/home"

## Framework adapter example

Its easy to make paradiso work with your favorite framework.

    Paradiso = require "paradiso"

    Paradiso.adapters.mylib = class
      constructor: ({ Component, Framework, @server }) ->
        @component = new Component()
      view: ->
        @component.view()

    new Paradiso(mylib: true)
      .routes
        "/": class view: "hello"

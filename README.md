# paradiso

Thin layer to run isomorphic apps on any javascript framework or web server.

## What it does

Paradiso provides a thin interface between web servers and frameworks.

Build apps that render statically on the first request, then turn dynamic.

Switch framework or web server at any time.

## Problem domains

* Routing
* Defining state
* Rendering views
* Bootstrapping data

## Server

`server.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      express: require "express"
      mithril: require "mithril"
      # react: require "react"
    .routes
      "/": require "./components/home"

## Home component

`components/home.coffee`:

### Mithril

    m = require "mithril"

    module.exports =
      controller: ->
        @title = "hello"
      view:   (c) ->
        m "html", m "title", c.title

### React

    module.exports = React.createClass
      componentDidMount: ->
        @setState title: "hello"
      render: ->
        <html>
          <title>{@state.title}</title>
        </html>

## Adapters

Paradiso supports:

* express
* mithril
* react

### Build an adapter

    module.exports = class
      @adapter: "lib-name"
      constructor: (lib) ->
      render: (instance) ->

# paradiso

Thin layer to run isomorphic apps on any javascript framework or web server.

## What it does

Paradiso provides a thin interface between web servers and frameworks.

Build apps that render statically on the first request, then turn dynamic.

Switch framework or web server at any time.

## Adapters

Web servers:

* express

Frameworks:

* mithril
* react

## Server

Create `server.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      express:   require "express"
      # mithril: require "mithril"
      # react:   require "react"
    .routes
      "/": require "./components/home"

## Home component

Create `components/home.coffee`:

### Coffee components

Paradiso ships with its own [default way of writing components](https://github.com/invrs/coffee-component).

    module.exports = class
      constructor: ->
        @title = "hello"

      View: class
        constructor: ({ @title } = { title }) ->
        view: 
          "<html><head>#{@title}</head></html>"

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

## Boot the server

By now you've created `server.coffee` and `component/home.coffee`.

Start the server:

    coffee server.coffee

### Build an adapter

    module.exports = class
      @adapter: "lib-name"
      constructor: (lib) ->
      render: (instance) ->

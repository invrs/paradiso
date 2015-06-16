Adapter = require "./paradiso/adapter"
Waiter  = require "./paradiso/waiter"

module.exports = class Paradiso

  constructor: ({ @express, @mithril }) ->
    @timeout = new Promise (@resolveTimeout) =>
    { @render, @server } = @adapters()

  adapters: ->
    adapters = {}

    if @express
      adapters.server =
        new Adapter.Server.Express @express

    if @mithril
      adapters.render =
        new Adapter.Render.Mithril @mithril

    adapters

  request: ({ Component, globals }) ->
    { server } = globals
    ended      = false

    Waiter.wait(globals).then (promises) =>
      return if ended
      ended = true

      if promises
        server.end @render.view component.view globals
      else
        server.status 500

    component =
      new Adapter.Component {
        Component, globals, @render
      }

    setTimeout(
      =>
        return if ended
        ended = true

        server.status 500
        @resolveTimeout { Component, globals }
      5000
    )

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        callback = (globals) =>
          @request { Component, globals }

        @server.get { path, callback }

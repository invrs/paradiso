Adapter = require "./paradiso/adapter"
Waiter  = require "./paradiso/waiter"

global.window ||= {}
global.window.setTimeout ||= setTimeout

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

  request: ({ Component, Globals }) ->
    ended = false

    component =
      new Adapter.Component({ Component, Globals, @render })
      .component()

    { server } = component

    Waiter.wait(component).then (promises) =>
      return if ended
      ended = true

      if promises
        server.end @render.view component
      else
        server.status 500

    setTimeout(
      =>
        return if ended
        ended = true

        server.status 500
        @resolveTimeout { Component, Globals }
      5000
    )

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        callback = (Globals) =>
          @request { Component, Globals }

        @server.get { path, callback }

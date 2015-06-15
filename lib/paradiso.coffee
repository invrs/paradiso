Adapter = require "./paradiso/adapter"
Waiter  = require "./paradiso/waiter"

module.exports = class Paradiso

  constructor: ({ @express, @mithril }) ->
    @timeout = new Promise (@timeoutResolve) =>
    { @framework, @server } = @adapters()

  adapters: ->
    adapters = {}

    if @express
      adapters.server =
        new Adapter.Server.Express @express

    if @mithril
      adapters.framework =
        new Adapter.Framework.Mithril @mithril

    adapters

  request: ({ Component, config, server }) ->
    ended = false

    Waiter.wait(config).then (promises) =>
      return if ended
      ended = true

      if promises
        server.end component.view()
      else
        server.status 500

    component = new Component { config }

    setTimeout(
      =>
        return if ended
        ended = true

        server.status 500
        @timeoutResolve { Component, config, server }
      5000
    )

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        Component =
          new Adapter.Component { Component, @framework }

        @server.get path, (config) =>
          @request { Component, config, @server }

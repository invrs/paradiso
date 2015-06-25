global.window ||= {}
global.window.setTimeout ||= setTimeout

Adapters = require "./paradiso/adapters"

module.exports = class Paradiso

  constructor: (libs) ->
    @adapters = new Adapters libs

  route: ({ Component, path }) ->
    composer = @adapters.composer { Component, path }

    if @adapters.server
      @server.get { composer, path, render: @adapters.render }
    else
      @adapters.render.component composer

    @

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        routes[path] = @route { Component, path }

    @adapters.render.routes routes
    @

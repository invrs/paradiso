global.window ||= {}
global.window.setTimeout ||= setTimeout

Adapters = require "./paradiso/adapters"

module.exports = class Paradiso

  constructor: (libs) ->
    @adapters = new Adapters libs
    { @render, @server } = @adapters

  route: ({ Component, path }) ->
    composer = @adapters.composer { Component, path }

    if @server
      @server.get {
        composer, path, render: @adapters.render
      }
    else
      @render.component composer

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        routes[path] = @route { Component, path }

    @render.routes routes
    routes

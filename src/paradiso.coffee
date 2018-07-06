global.window ||= {}
global.window.setTimeout ||= setTimeout

Adapters = require "./paradiso/adapters"

module.exports = class Paradiso

  constructor: (libs) ->
    @adapters = new Adapters libs
    { @render, @server } = @adapters

  route: ({ Component, path }) ->
    console.log { Component, path }
    composer = @adapters.composer { Component, path }

    console.log composer
    if @server
      @server.get {
        composer, path, render: @adapters.render
      }
    else
      @render.component composer

  routes: (routes={}, element) ->
    for path, Component of routes
      do (path, Component) =>
        routes[path] = @route { Component, path }

    @render.routes routes, element
    routes

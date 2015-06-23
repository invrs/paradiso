Composer = require "./paradiso/adapter/composer"
Server   = require "./paradiso/adapter/server"
Render   = require "./paradiso/adapter/render"

global.window ||= {}
global.window.setTimeout ||= setTimeout

module.exports = class Paradiso

  constructor: (libs) ->
    @libs = @adapters libs
    { @render, @server } = @libs

  adapters: (libs) ->
    adapters = {}

    for name, lib of libs
      do (name, lib) =>
        switch name
          when "express"
            adapters.server =
              new Server.Express lib

          when "mithril"
            adapters.render =
              new Render.Mithril lib

          else
            adapters[name] = lib

    adapters

  route: ({ Component, path }) ->
    if typeof Component == "object"
      adapter  = Object.keys(Component)[0]
      composer = new @libs[adapter] {
        Component: Component[adapter], path, @render, @server
      }
    else
      composer = new Composer {
        Component, path, @render, @server
      }

    if @server
      @server.get { composer, path, @render }
    else
      @render.component composer

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        routes[path] = @route { Component, path }

    @render.routes routes
    @

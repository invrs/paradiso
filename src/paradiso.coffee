Adapter = require "./paradiso/adapter/component"
Server  = require "./paradiso/adapter/server"
Render  = require "./paradiso/adapter/render"

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
        new Server.Express @express

    if @mithril
      adapters.render =
        new Render.Mithril @mithril

    adapters

  route: ({ Component, path }) ->
    adapter = new Adapter { Component, @render }

    if @server
      @server.get { adapter, path, @render }
    else
      @render.component adapter

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        routes[path] = @route { Component, path }

    @render.routes routes
    @

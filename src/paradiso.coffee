Composer = require "./paradiso/adapter/composer"
Server   = require "./paradiso/adapter/server"
Render   = require "./paradiso/adapter/render"

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
    composer = new Composer {
      Component, path, @render, @server, @timeout
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

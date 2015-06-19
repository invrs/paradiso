Server = require "./paradiso/adapter/server"
Render = require "./paradiso/adapter/render"

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

  routes: (routes={}) ->
    for path, Component of routes
      do (path, Component) =>
        if @server
          @server.get { Component, path, @render }
        else
          routes[path] = @render.component { Component }

    @render.routes routes

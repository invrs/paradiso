Composer = require "./paradiso/adapter/composer"

module.exports = class
  constructor: (libs) ->
    for name, lib of libs
      do (name, lib) =>
        switch name
          when "express"
            Server  = require "#{""}./paradiso/adapter/server"
            @server = new Server.Express lib

          when "mithril"
            Render  = require "./paradiso/adapter/render"
            @render = new Render.Mithril lib

          else
            @[name] = lib

  composer: ({ Component, path }) ->
    if typeof Component == "object"
      adapter = Object.keys(Component)[0]
      new @[adapter] {
        Component: Component[adapter], path, @render, @server
      }
    else
      new Composer {
        Component, path, @render, @server
      }

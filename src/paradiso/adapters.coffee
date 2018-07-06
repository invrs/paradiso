Composer = require "./adapters/composer"

module.exports = class
  constructor: (libs) ->
    for name, lib of libs
      do (name, lib) =>
        switch name
          when "express"
            Server  = require "#{""}./adapters/server"
            @server = new Server.Express lib

          when "extensions"
            @extensions = lib

          when "mithril"
            Render  = require "./adapters/render"
            @render = new Render.Mithril lib

          else
            @[name] = lib

  composer: ({ Component, path }) ->
    if typeof Component == "object"
      adapter = Object.keys(Component)[0]
      new @[adapter] {
        adapters:  @
        Component: Component[adapter]
        @extensions
        path
        @render
        @server
      }
    else
      new Composer {
        adapters:  @
        Component
        @extensions
        path
        @render
        @server
      }

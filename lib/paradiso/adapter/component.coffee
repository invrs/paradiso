mix = require("coffee-mixin")

module.exports = class
  constructor: ({ Component, @globals, @render }) ->
    Mixin = class
      buildHelper = ({ globals, Klass, fn_name, var_name }) ->
        (args...) ->
          key = if typeof args[0] == "string"
            args.shift()

          if fn_name.match(/View$/)
            new Klass(globals, args...).view()
          else if key
            @["#{var_name}_#{key}"] ||=
              new Klass globals, args...
          else
            @[var_name] ||=
              new Klass globals, args...

      klassToFnName = (name) ->
        name.charAt(0).toLowerCase() + name.slice(1)

      klassToVarName = (name) ->
        name
          .replace(/([A-Z])/g, "_$1")
          .toLowerCase()
          .substring(1)

      constructor: (globals, args...) ->
        for name, Klass of @
          do (name, Klass) =>
            if name.match(/^[A-Z]/)
              fn_name  = klassToFnName(name)
              var_name = klassToVarName(name)

              @[fn_name] = buildHelper {
                globals, Klass, fn_name, var_name
              }

        super args...

      r: (args...) -> @render.render args...

    @Component = mix Component, Mixin

  view: ->
    new @Component(@globals).view()

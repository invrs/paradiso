Composer = require "../composer"

module.exports = (compose_options) ->
  class
    constructor: (options) ->
      for name, Component of @
        do (name, Component) =>
          if name.match(/^[A-Z]/)
            fn_name  = klassToFnName(name)
            var_name = klassToVarName(name)

            composer = compose_options.adapters.composer {
              Component
            }

            @[name] = (args...) ->
              composer.component(args...)

            @[fn_name] = buildHelper({
              composer, fn_name, var_name
            }).bind @

      super

    buildHelper = ({ composer, fn_name, var_name }) ->
      (args...) ->
        key_types = [ "number", "string" ]
        key = if key_types.indexOf(typeof args[0]) > -1
          args.shift()

        args[0]        ||= {}
        args[0]._globals = @_globals

        component = composer.component.bind(composer)

        if fn_name.match(/View$/)
          return component(args...).view()
        
        if key
          id = "#{var_name}_#{key}"
        else
          id = var_name

        @_components ||= {}

        if @_components[id]
          for k, v of args[0]
            @_components[id][k] = v
        else
          @_components[id] ||= component(args...)

        @_components[id]

    klassToFnName = (name) ->
      name.charAt(0).toLowerCase() + name.slice(1)

    klassToVarName = (name) ->
      name
        .replace(/([A-Z])/g, "_$1")
        .toLowerCase()
        .substring(1)

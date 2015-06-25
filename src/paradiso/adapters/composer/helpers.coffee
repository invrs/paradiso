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

            @[fn_name] = buildHelper {
              composer, fn_name, var_name
            }

      super

    buildHelper = ({ composer, fn_name, var_name }) ->
      (args...) ->
        key = if typeof args[0] == "string"
          args.shift()

        args[0]       ||= {}
        args[0].globals = @_globals

        component = composer.component.bind(composer)

        if fn_name.match(/View$/)
          component(args...).view()
        else if key
          @_components ||= {}
          @_components["#{var_name}_#{key}"] ||= component(args...)
        else
          @_components ||= {}
          @_components[var_name] ||= component(args...)

    klassToFnName = (name) ->
      name.charAt(0).toLowerCase() + name.slice(1)

    klassToVarName = (name) ->
      name
        .replace(/([A-Z])/g, "_$1")
        .toLowerCase()
        .substring(1)

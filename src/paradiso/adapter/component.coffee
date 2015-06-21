{ multi } = require "heterarchy"

module.exports = class ComponentAdapter
  constructor: ({ Component, @globals, render }) ->
    Helpers = class
      constructor: (options) ->
        for key, value of options.globals
          @[key] = value
        
        for name, Klass of @
          do (name, Klass) =>
            if name.match(/^[A-Z]/)
              fn_name  = klassToFnName(name)
              var_name = klassToVarName(name)

              component = =>
                new ComponentAdapter({ Component: Klass, render })
                .component(@)

              @[fn_name] = buildHelper({
                component, fn_name, var_name
              })

      buildHelper = ({ component, fn_name, var_name }) ->
        (args...) ->
          key = if typeof args[0] == "string"
            args.shift()

          if fn_name.match(/View$/)
            component().view()
          else if key
            @_components ||= {}
            @_components["#{var_name}_#{key}"] ||= component()
          else
            @_components ||= {}
            @_components[var_name] ||= component()

      klassToFnName = (name) ->
        name.charAt(0).toLowerCase() + name.slice(1)

      klassToVarName = (name) ->
        name
          .replace(/([A-Z])/g, "_$1")
          .toLowerCase()
          .substring(1)

      r: (args...) -> render.render args...

    Extensions =
      multi Helpers, render.Component, Component

    @Component = class extends Extensions
      constructor: -> super
      promises: []
    
  component: (options) ->
    new @Component options

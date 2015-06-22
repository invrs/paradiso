module.exports = class ComponentAdapter
  constructor: ({ Component, render }) ->
    Helpers = class
      constructor: (options) ->
        @globals = options.globals

        for name, Klass of @
          do (name, Klass) =>
            if name.match(/^[A-Z]/)
              fn_name  = klassToFnName(name)
              var_name = klassToVarName(name)

              component = (args...) =>
                args[0] ||= {}
                args[0].globals = @globals

                new ComponentAdapter({ Component: Klass, render })
                .component(args...)

              @[fn_name] = buildHelper({
                component, fn_name, var_name
              })

        for key, value of @globals
          @[key] = value

        for key, value of render.tags()
          @[key] = value

        @p = (args...) -> render.prop args...
        @r = (args...) -> render.redraw args...

        super

      buildHelper = ({ component, fn_name, var_name }) ->
        (args...) ->
          key = if typeof args[0] == "string"
            args.shift()

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

    A = Component
    B = class
      constructor: ->
        @promises = []
        super
    C = Helpers

    @Component = C extends B extends A
    
  component: (options={}) ->
    new @Component options

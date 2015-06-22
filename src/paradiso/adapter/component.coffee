module.exports = class Adapter
  constructor: ({ Component, render }) ->

    Helpers = class
      constructor: (options) ->
        @_globals = options.globals

        for name, Klass of @
          do (name, Klass) =>
            if name.match(/^[A-Z]/)
              fn_name  = klassToFnName(name)
              var_name = klassToVarName(name)
              adapter  = new Adapter { Component: Klass, render }

              @[fn_name] = buildHelper {
                adapter, fn_name, var_name
              }

        for key, value of @_globals
          @[key] = value

        for key, value of render.tags()
          @[key] = value

        @p = (args...) -> render.prop args...
        @r = (args...) -> render.redraw args...

        super

      buildHelper = ({ adapter, fn_name, var_name }) ->
        (args...) ->
          key = if typeof args[0] == "string"
            args.shift()

          args[0]       ||= {}
          args[0].globals = @_globals

          component = adapter.component.bind(adapter)

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

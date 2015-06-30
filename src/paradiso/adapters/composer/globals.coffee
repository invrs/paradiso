module.exports = ->
  class
    constructor: (options) ->
      if options.globals
        @globals = options.globals

        for key, value of @globals
          @[key] = value

      super

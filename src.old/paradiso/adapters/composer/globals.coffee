module.exports = ->
  class
    constructor: (options) ->
      if options._globals
        @_globals = options._globals

        for key, value of @_globals
          @[key] = value

      super

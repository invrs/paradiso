module.exports = ->
  class
    constructor: (options) ->
      @_globals = options.globals

      for key, value of @_globals
        @[key] = value

      super

module.exports = ->
  class
    constructor: ->
      @_promises = []
      super

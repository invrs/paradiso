module.exports = ({ render }) ->
  class
    constructor: ->
      @p = (args...) -> render.prop args...
      super

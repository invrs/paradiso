module.exports = ({ render }) ->
  class
    constructor: ->
      @r = (args...) -> render.redraw args...
      super

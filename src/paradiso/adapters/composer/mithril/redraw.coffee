module.exports = ({ render }) ->
  class
    constructor: ->
      @r = (args...) -> render.mithril.redraw args...
      super

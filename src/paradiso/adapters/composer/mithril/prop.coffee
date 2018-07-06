module.exports = ({ render }) ->
  class
    constructor: ->
      @p = (args...) -> render.mithril.prop args...
      super

module.exports = ({ render }) ->
  class
    constructor: ->
      @d = (args...) -> render.mithril.deferred args...
      super

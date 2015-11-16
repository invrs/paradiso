sugartags = require "mithril.sugartags"

module.exports = ({ render }) ->
  class
    constructor: ->
      sugartags render.mithril, @
      super

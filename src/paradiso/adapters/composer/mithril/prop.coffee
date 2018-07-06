prop = require "mithril/stream"

module.exports = ({ render }) ->
  class
    constructor: ->
      @p = (args...) -> prop args...
      super

render    = require "mithril-node-render"
sugartags = require "mithril.sugartags"

module.exports = class

  constructor: (@mithril) ->
    sugartags @mithril, @Component.prototype

  Component: class

  render: (force) ->
    @mithril.render force

  view: (component) ->
    render component.view()

render = require "mithril-node-render"

module.exports = class

  constructor: (@mithril) ->

  render: (force) ->
    @mithril.render force

  view: (component) ->
    render component.view()

sugartags        = require "mithril.sugartags"
ComponentAdapter = require "../component"

unless document?
  render = require "mithril-node-render"

module.exports = class

  constructor: (@mithril) ->
  
  component: ({ Component }) ->
    globals = @globals()
    render  = @

    component = new ComponentAdapter({ Component, render })
    .component({ globals })

    controller: -> component
    view:   (c) -> c.view()

  globals: ->
    m = @mithril
    params: m.route.param

  prop: (args...) ->
    @mithril.prop args...

  render: (args...) ->
    @mithril.render args...

  routes: (routes) ->
    if document?
      @mithril.route document.body, "/", routes

  tags: ->
    sugartags @mithril, {}

  view: (component) ->
    if document?
      component.view()
    else
      render component.view()

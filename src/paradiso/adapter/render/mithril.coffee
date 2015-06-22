unless document?
  render = require "#{""}mithril-node-render"

module.exports = class

  constructor: (@mithril) ->

  component: (composer) ->
    globals   = @globals()
    component = composer.component { globals }

    controller: -> component
    view:   (c) -> c.view()

  globals: ->
    m = @mithril
    params: m.route.param

  prop: (args...) ->
    @mithril.prop args...

  redraw: (args...) ->
    @mithril.redraw args...

  render: (args...) ->
    @mithril.render args...

  routes: (routes) ->
    if document?
      @mithril.route document.body, "/", routes

  view: (component) ->
    if document?
      component.view()
    else
      render component.view()

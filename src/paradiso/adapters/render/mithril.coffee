Waiter = require "../server/waiter"

unless document?
  render = require "#{""}mithril-node-render"

module.exports = class

  constructor: (@mithril) ->

  component: (composer) ->
    _globals = @globals()

    controller: ->
      component = composer.component { _globals }
      
      if window?
        window.paradisoReady = -> Waiter.wait(component)
      
      component

    view: (c) -> c.view()

  globals: ->
    m = @mithril
    params: m.route.param

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

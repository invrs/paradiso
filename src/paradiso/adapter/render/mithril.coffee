sugartags        = require "mithril.sugartags"
ComponentAdapter = require "../component"

unless document?
  render = require "mithril-node-render"

module.exports = class

  constructor: (@mithril) ->
    sugartags @mithril, @Component.prototype

  component: ({ Component }) ->
    Globals = @globals()
    render  = @

    component = new ComponentAdapter({
      Component, Globals, render
    }).component()

    controller: -> component
    view:   (c) -> c.view()

  Component: class

  globals: ->
    m = @mithril
    class
      params: m.route.param

  render: (force) ->
    @mithril.render force

  routes: (routes) ->
    if document?
      @mithril.route document.body, "/", routes

  view: (component) ->
    if document?
      component.view()
    else
      render component.view()

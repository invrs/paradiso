sugartags = require "mithril.sugartags"
Component = require "../component"

unless document?
  render = require "mithril-node-render"

module.exports = class

  constructor: (@mithril) ->
    sugartags @mithril, @Component.prototype

  component: ({ Component }) ->
    Globals = @globals()
    render  = @

    component = new Component({
      Component, Globals, render
    }).component()

    controller: -> component
    view:   (c) -> c.view()

  Component: class

  globals: ->
    class
      params: @mithril.route.param

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

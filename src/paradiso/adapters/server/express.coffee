Waiter = require "./waiter"

module.exports = class Express

  constructor: (express) ->
    @express = express()

  get: ({ composer, path, render }) ->
    @express.get path, (req, res, next) =>
      _globals  = @globals { req, res }
      component = composer.component { _globals }

      if component.server?.halt
        component.server.end()
        return

      res.type component.response_type || composer.Component.response_type || "html"

      @request { component, render }

  globals: ({ req, res }) ->
    params: req.params
    server:
      req: req
      res: res
      status: (code) ->
        res.status(code).end()
      end: (response) ->
        res.end response

  request: ({ component, render }) ->
    ended      = false
    { server } = component

    console.log("paradiso waiter start")
    Waiter.wait(component).then ({ error }) =>
      console.log("paradiso waiter callback", error)

      return if ended
      ended = true

      if !error || component.server?.force_render
        console.log("paradiso server.end", component.server?.force_render)
        server.end render.view component
      else
        server.status 500
        @rejected { component } if @rejected

    unless component.constructor.disable_timeout
      setTimeout(
        =>
          return if ended
          ended = true

          server.status 500
          @timeout { component } if @timeout
        @timeout_ms || 5000
      )

Waiter = require "./waiter"

module.exports = class Express

  constructor: (express) ->
    @express = express()

  get: ({ composer, path, render }) ->
    @express.get path, (req, res, next) =>
      globals   = @globals { req, res }
      component = composer.component { globals }

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

    Waiter.wait(component).then (promises) =>
      return if ended
      ended = true

      if promises
        server.end render.view component
      else
        server.status 500

    setTimeout(
      =>
        return if ended
        ended = true

        server.status 500
        @timeout { component } if @timeout
      5000
    )

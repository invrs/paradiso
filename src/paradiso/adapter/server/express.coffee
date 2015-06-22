Waiter = require "./waiter"

module.exports = class Express

  constructor: (express) ->
    @express = express()

  get: ({ adapter, path, render }) ->
    @express.get path, (req, res, next) =>
      globals   = @globals { req, res }
      component = adapter.component { globals }

      @request { component, render }

  globals: ({ req, res }) ->
    params: req.params
    server:
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
        @resolveTimeout { component }
      5000
    )

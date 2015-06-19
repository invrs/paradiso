ComponentAdapter = require "../component"
Waiter           = require "./waiter"

module.exports = class Express

  constructor: (express) ->
    @app = express()

  get: ({ Component, path, render }) ->
    @app.get path, (req, res, next) =>
      Globals = @globals { req, res }

      component = new ComponentAdapter({
        Component, Globals, render
      }).component()

      @request { component, Globals, render }

  globals: ({ req, res }) ->
    class
      params: req.params
      server:
        status: (code) ->
          res.status(code).end()
        end: (response) ->
          res.end response

  request: ({ component, Globals, render }) ->
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
        @resolveTimeout { component, Globals }
      5000
    )

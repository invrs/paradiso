module.exports = class Express

  constructor: (express) ->
    @app = express()

  get: ({ callback, path }) ->
    @app.get path, (req, res, next) ->
      Globals = class
        params: req.params
        server:
          status: (code) ->
            res.status(code).end()
          end: (response) ->
            res.end response
      
      callback Globals

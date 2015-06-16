Paradiso = require "../../lib/paradiso"
request  = require "supertest"

describe "Paradiso", ->

  beforeEach ->
    @iso = new Paradiso(
      express: require "express"
      mithril: require "mithril"
    )

  describe "thing", ->
    it "works", (done) ->
      @iso.routes
        "/": class
          view: "hello"
      request(@iso.server.app)
        .get("/")
        .expect(200)
        .end (err, res) ->
          # if err then return done(err)
          # done()

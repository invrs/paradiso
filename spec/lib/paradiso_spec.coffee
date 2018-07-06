#require("mithril/test-utils/browserMock")(global)
# Polyfill DOM env for mithril
global.window = require("mithril/test-utils/browserMock.js")();
global.document = window.document;
Paradiso = require "../../lib/paradiso"
request  = require "supertest"
prop = require "mithril/stream"

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
          constructor: ->
            @title = prop "Welcome"
            @user  = prop new @UserModel()

          view: ->
            new @HomeView @

          HomeView: class
            constructor: ({ @title, @user }) ->

            header: ->
              "Hello, #{@user().name}"

            view: ->
              if @server
                @HTML [
                  @HEAD @TITLE @title()
                  @BODY @header()
                ]
              else
                @header()

          UserModel: class
            constructor: -> @name = "Joe"

      request(@iso.server.express)
        .get("/")
        .expect(200, "<html><head><title>Welcome</title></head><body>Hello, Joe</body></html>")
        .end (err, res) ->
          if err then throw err
          done()

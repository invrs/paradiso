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
          constructor: ->
            @title = "Welcome"

          view: ->
            @homeView()

          HomeView: class
            constructor: ({ @title, @user }) ->

            header: ->
              "Hello, #{@user().name}"
            
            view: ->
              if @server
                "<html>#{@header()}</html>"
              else
                @header()

          User: class
            constructor: -> @name = "Joe"

      request(@iso.server.app)
        .get("/")
        .expect(200, "hello")
        .end (err, res) ->
          if err then throw err
          done()

# Paradiso

A common way to write reactive and isomorphic apps on any js framework.

## Features

Provides a standard style for defining components and routes.

Aims to be simple, unobtrusive, and more traditionally object-oriented.

Change rendering engines and web servers in two lines of code.

Easy to write adapters for your favorite framework.

## Adapters

#### Rendering

* mithril
* react

#### Web server

* express

## Components

Create `components/home.coffee`:

    module.exports = class
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
            @HTML [
              @HEAD @TITLE @title
              @BODY @header()
            ]
          else
            @header()

      User: class
        constructor: ->
          @name = "Joe"

While somewhat of a contrived example, you can see how uni-directional data flow works with traditional classes.

#### Component basics

* Components typically have a `view` function
* The `@params` object is always present and holds route parameters
* If you have a promise that needs resolution before the server should render your views, push it to `@promises`
* The `@server` variable exists when rendering server side

#### Helper functions

When you define a component within a component (`User`), Paradiso generates a helper method (`@user`) to accompany it.

Calling the `@user()` helper method creates an instance of the `User` component and keeps a reference to it next time you call it.

#### Stateful vs stateless

If a component is stateful, that means its class instance variables maintain state across multiple renders.

Renders don't just occur when you visit a new URL. They can happen repeatedly as dynamic actions take place.

#### View components

Name your view components with the word `View` at the end of it (`HomeView`).

View classes are stateless. View classes only exist for the lifetime of a single render.

The helper function knows not to preserve state on View components. It also knows to automatically call the `view` function and return its result on View classes.

#### Similar components

Sometimes you need to store multiple instances of the same stateful component.

To ensure a component keeps its own distinct state, call the component's helper method with an `id` argument:

    @myComponent 1
    @myComponent 2

## Routes

Create `routes.coffee`:

    module.exports =
      "/": require "./components/home"

## Client

Create `client.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      # Framework (uncomment one):
      #
      # mithril: require "mithril"
      # react:   require "react"

    .routes require "./routes"

## Server

Create `server.coffee`:

    Paradiso = require "paradiso"

    new Paradiso
      # Web server:
      #
      express: require "express"

      # Framework (uncomment one):
      #
      # mithril: require "mithril"
      # react:   require "react"

    .routes require "./routes"

## Start the server

You should now have the following files:

* `component/home.coffee`
* `routes.coffee`
* `client.coffee`
* `server.coffee`

Now start the server:

    coffee server.coffee

## Converting your project

Paradiso allows you to mix and match between common and framework-specific component styles while you convert your project.

Just specify the style in the route:

    module.exports =
      "/": mithril: require "./components/home"

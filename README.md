# Paradiso

A common way to write reactive and isomorphic apps on any js framework.

## Features

Provides a standard style for defining components and routes.

Change rendering and routing engines in one line of code.

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
        @title = "title"

      view: ->
        @homeView()

      HomeView: class
        constructor: ({ @title }) ->

        header: -> H1 @title
        
        view:
          if @server
            HTML [
              HEAD TITLE @title
              BODY @header()
            ]
          else
            @header()

#### Component basics

* Components typically have a `view` function
* The `@params` object is always present and holds route parameters
* If you have a promise that needs resolution before the server should render your views, push it to `@promises`
* The `@server` variable exists when rendering server side

#### Helper functions

When you define a class within your component (`HomeView`), Paradiso generates a helper method (`@homeView`) to accompany it.

Calling the `@homeView()` helper method creates an instance of the `HomeView` component and calls the `view()` method on it.

#### Stateful vs stateless

If a component is stateful, that means its class instance variables maintain state across multiple renders.

View classes should only exist for the lifetime of the individual render. Paradiso knows to make `HomeView` a stateless component because of the word `View` at the end of it.

Name a class without `View` at the end, and it will be automatically be stateful.

#### Similar components

Sometimes you need to store multiple instances of the same component.

To ensure a component keeps its own state, call the component's helper method with an `id` argument:

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

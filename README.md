# Paradiso

The hacker's framework for building universal web apps.

## Its just an app

Paradiso is a universal web app with no major framework dependencies. It prints "hello world".

You can boot it right out of the box:

```bash
> npm install paradiso
> node -e "require('paradiso').app().server()"
>
> Server started on port 3000!
```

## But its not boilerplate!

Even though Paradiso reads as a boilerplate app, you still use it like a framework.

Paradiso introduces a way to add functionality by modifying the class inheritance hierarchy of the app. Any function in the Paradiso app can be extended or modified.

Paradiso urges you to write app code in a library-agnostic way. The framework provides the `browserify`, `express`, and `mithril` extensions to serve as an example of how to achieve this goal.

## Architecture

Typically exposing the inner workings of a framework to be extended and modified by the end user would be a syntactic and logistical challenge. The [Industry.js factory pattern](https://github.com/invrs/industry) creates conventions that make this method an elegant approach.

Paradiso exports four main [factory builders](https://github.com/invrs/industry/blob/master/READMORE.md#factory-basics): `app`, `build`, `component`, and `server`.

The class you pass to the factory builder defines the base class. Paradiso [extends](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) your base class to add Paradiso's functionality.

Because you own the base class, you can modify the final step of any Paradiso function. This is how you add logic and configuration that changes how the app works.

Additionally, you can call [extend](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) on your own factories to execute logic before Paradiso, or stop Paradiso's logic from running entirely.

## The big picture

Paradiso is designed for engineers who want a deeper understanding of their framework and app code. Engineers are closer to the framework code, which makes it easier to modify and contribute to.

It is our hope that Paradiso extends the lifetime of app code by making it adaptable, reusable, and comprehensible.

## Start your project

First, let's create a simple project with the following structure:

```
- app.js
- app/
  - build.js
  - component.js
  - server.js
- components/
  - home.js
```

#### App factory

`app.js`:

```js
import { app } from "paradiso"

class App {
  build() {
    return this.app.build()
  }

  component() {
    return this.app.component()
  }

  routes() {
    return { "/": this.components.home }
  }

  server() {
    return this.app.server()
  }
}

export default app(App).include(__dirname)
```

#### Build factory

`build.js`:

```js
import { build, browserify } from "paradiso"

export default build.extend(browserify)
```

#### Component factory

`component.js`:

```js
import { component, mithril } from "paradiso"

export default component.extend(mithril)
```

#### Server factory

`server.js`: 

```js
import { server, express } from "paradiso"

export default server.extend(express)
```

### Component factory

`components/home.js`:

```js
import { component } from "paradiso"

class Home {
  view() { return "hello!" }
}

export default component(Home)
```

### Build assets

```bash
node -e "require('./app').build()"
```

### Start web server

```bash
node -e "require('./app').server()"
```

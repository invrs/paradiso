# Paradiso

The hacker's framework for building universal web apps.

## Its just an app

Paradiso is a universal web app that prints "hello world".

You can boot it right out of the box:

```bash
> npm install paradiso
> node -e "require('paradiso').app().server()"
>
> Server started on localhost:3000
```

It has no major framework dependencies.

## But its not boilerplate!

Even though Paradiso reads as a boilerplate app, you still use it like a framework.

Paradiso introduces a way to add functionality by extending the class inheritance hierarchy.

This approach puts the author closer to the framework code and offers a better understanding of what is happening behind the scenes.

## Paradise through factories

Adding functionality through inheritance presents a lot of challenges. The [Industry.js factory pattern](https://github.com/invrs/industry) creates conventions that makes this approach elegant with huge upside.

Paradiso exports four main [factory builders](https://github.com/invrs/industry/blob/master/READMORE.md#factory-basics): `app`, `build`, `component`, and `server`.

Create a factory by passing your base class to one of the factory builders. The factory builder [extends](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) your base class to add Paradiso's subclasses.

Because you own the base class, you can modify the final step of any Paradiso function. This is how you add logic and configuration that changes how the app works.

## Library agnostic

Paradiso encourages you to write library agnostic app code.

Paradiso exports the `browserify`, `express`, and `mithril` subclasses to serve as examples of how to achieve this.

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

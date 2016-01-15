# Paradiso

The hacker's framework for building universal web apps.

## Philosophy

Paradiso is essentially a barebones universal web app that you can run out of the box:

```bash
> npm install paradiso
> node -e "require('paradiso').app().server()"
>
> Server started on port 3000!
```

Instead of using boilerplate and versioning, you modify the app through an intuitive class inheritance structure.

Paradiso was designed for engineers who want a complete understanding of their stack. Engineers intrinsically learn Paradiso's source code by nature of building their app.

Finally, Paradiso urges you to write your app code in a library-agnostic way. The framework provides the `browserify`, `express`, and `mithril` subclasses to serve as an example of how to achieve this goal.

## Architecture

Paradiso is built with [Industry.js](https://github.com/invrs/industry), an awesome factory pattern.

Paradiso exports four main [factory builders](https://github.com/invrs/industry/blob/master/READMORE.md#factory-basics): `app`, `build`, `component`, and `server`.

The class you pass to the factory builder defines the base class. Paradiso [extends](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) your base class to add Paradiso's functionality.

Because you own the base class, you can modify the final logic of any Paradiso function. This is how you execute custom logic and write configuration values that change how the barebones app works.

Additionally, you can call [extend](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) on your own factories to execute logic before Paradiso, or stop Paradiso's logic from running entirely.

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

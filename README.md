# Paradiso

A framework for building universal, library-agnostic Node.js web apps.

## Features

Paradiso defines an API for common functions of a univeral web app (e.g., component functionality, web server, asset compilation).

The [Industry](https://github.com/invrs/industry) pattern keeps code clean, testable, and extensible.

## Install

```bash
npm install -g paradiso
```

## Architecture

Importing Paradiso exposes four [factory builders](https://github.com/invrs/industry/blob/master/READMORE.md#factory-basics): `app`, `build`, `client`, and `server`.

The class you pass to the factory builder defines the base class. Your base class is [extended](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) to add Paradiso's functionality.

Paradiso ships as a functioning app as soon as you install it:

```bash
node -e "require('paradiso').app().server()"
```

Because you own the base class, you can modify the output of any Paradiso function. This is how you execute custom logic and write configuration values that change how the barebones app works.

Additionally, you can call [extend](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) on your own factories to execute logic before Paradiso does, or stop Paradiso's logic from running entirely.

Paradiso was designed for exploration and comprehension of what goes on under the hood. It mandates that you become intimate with its API in order to use it.

Finally, the framework urges you to write your app code in a library-agnostic way. Paradiso provides the `browserify`, `express`, and `mithril` extensions to serve as an example of how to achieve this.

## Start your project

First, let's create a very simple project with the following structure:

- app.js
- build.js
- client.js
- server.js
- components/home.js

(**Protip**: Feel free to organize your files how you like. Paradiso is unopinionated.)

#### App initializer

`app.js`:

```js
import { app } from "paradiso"

class App {
  routes() {
    return { "/": this.components.home }
  }
}

export default app(App).include(__dirname)
```

#### Build initializer

`build.js`:

```js
import { build, browserify } from "paradiso"

export default build.extend(browserify)
```

#### Client initializer

`client.js`:

```js
import { client, mithril } from "paradiso"

export default client.extend(mithril)
```

#### Server initializer

`server.js`: 

```js
import { server, express } from "paradiso"

export default server.extend(express)
```

### Component

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

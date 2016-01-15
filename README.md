# Paradiso

The hacker's javascript framework for building universal web apps.

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

Paradiso exports five main [factory builders](https://github.com/invrs/industry/blob/master/READMORE.md#factory-basics): `app`, `build`, `client`, `component`, and `server`.

The class you pass to the factory builder defines the base class. Your base class is [extended](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) to add Paradiso's functionality.

Because you own the base class, you can modify the output of any Paradiso function. This is how you execute custom logic and write configuration values that change how the barebones app works.

Additionally, you can call [extend](https://github.com/invrs/industry/blob/master/READMORE.md#extend-factories) on your own factories to execute logic before Paradiso does, or stop Paradiso's logic from running entirely.

## Start your project

First, let's create a very simple project with the following structure:

```
app.js
build.js
client.js
server.js
- components/
  home.js
```

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

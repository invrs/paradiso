# Paradiso

A library-agnostic framework for building concise, testable, and universal Node.js web apps.

## Features

Switch out underlying libraries without changing application code.

Uses the [definite](https://github.com/invrs/definite) pattern to keep code clean, testable, and extensible.

## Install

```bash
npm install -g paradiso
```

## The basics

Paradiso is just a custom [definite](https://github.com/invrs/definite) class builder. Please [read more about definite](https://github.com/invrs/definite) if you haven't.

Paradiso classes have the following `definite` instances available:

* [this.client](https://github.com/invrs/paradiso/blob/master/src/paradiso/client.coffee)
* [this.compress](https://github.com/invrs/paradiso/blob/master/src/paradiso/compress.coffee)
* [this.package](https://github.com/invrs/paradiso/blob/master/src/paradiso/package.coffee)
* [this.route](https://github.com/invrs/paradiso/blob/master/src/paradiso/route.coffee)
* [this.server](https://github.com/invrs/paradiso/blob/master/src/paradiso/server.coffee)

## Getting started

First, let's create a very simple project with the following structure:

    app/
      components/
        - home.js
      init/
        - app.js
        - build.js
        - client.js
        - server.js
      styles/
        - main.scss

(**Protip**: Feel free to organize your files how you like. Paradiso is unopinionated.)

### Initializers

The `app/init` directory includes:
 
* `build.js` - builds the client js asset
* `client.js` - defines the client js asset
* `routes.js` - routes for client and server
* `server.js` - starts the web server

#### Build initializer

`app/init/build.js`:

```js
import paradiso from "paradiso"

const ENV = process.env.NODE_ENV

export default paradiso(class {
  compress() {
    if (ENV != "production")
      return Promise.resolve()

    return super.compress({
      css: "../public/styles",
      js: "../public/client"
    })
  }

  package() {
    return super.package({
      css: "../app/styles/main",
      js: "../app/init/client",
      target: "../public/client"
    })
  }

  then() {
    return this.package().then(compress())
  }
})
```

#### App initializer

`app/init/app.js`:

```js
import paradiso from "paradiso"

export default paradiso(class {
  route() {
    return super.route({
      "/": "../components/home"
    })
  }

  server() {
    return super.server({
      port:   9000
      static: "public"
    })
  }
})
```

#### Client initializer

`app/init/client.js`:

```js
import app from "./app"

export default app().client()
```

#### Server initializer

`app/init/server.js`: 

```js
import app from "./app"

export default app().server()
```

### Component

`components/home.js`:

```js
import def from "definite"

module.exports = def(class {
  then() { return "hello!" }
})
```

### Build assets

Use the [`def` command](https://github.com/invrs/definite#definite-executor) to run your initialization classes:

```bash
def init/client
```

### Start server

Start the web server:

```bash
def init/server
```

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

This project is available in the [getting-started](https://github.com/invrs/paradiso-example/tree/getting-started) branch of the example repo.

### Components

Let's build a more complex HTML page with content:

`lib/view.js`:

```js
import paradiso from "paradiso"

export default paradiso({
  autoload: "../"
  key: null  // Views should not hold state
})
```

`components/layout.view.js`:

```js
import view from "../lib/view"

export default view(class {
  then() {
    return HTML [
      HEAD(this.options.title)
      BODY(this.options.content)
    ]
  }
})
```

`components/home.js`:

```js
import paradiso from "paradiso"

paradiso({ autoload: "./" })

export default paradiso(class {
  then() {
    let title = `home`
    let content = [
      H1(this.title),
      P(`hello`)
    ]

    if this.options.server
      return this.layout.view(null, { content, title })
    else
      return content
  }
})
```

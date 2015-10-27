# Paradiso

An adapter-based, library-agnostic framework for building web applications.

## Features

Switch out underlying libraries without changing application code.

Build resuable component, framework, and server adapters that operate transparently.

Adapters for `Express`, `Mithril`, `Browserify`, `Coffeeify`, `Envify`, `Uglify`, and more.

## Install

```bash
npm install -g paradiso
```

## Getting started

First, let's create a very simple project with the following structure:

    app/
      components/
        - home.js
      init/
        - build.js
        - client.js
        - routes.js
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
import { browserify, env, sass, minify, uglify } from "paradiso"

let build = browserify({
  "../app/init/client": "../public/client"
}).then(sass({
  "../app/styles/main": "../public/styles"
}))

if env == "production"
  build
    .then(uglify("../public/client"))
    .then(minify("../public/styles"))
```

#### Routes initializer

`app/init/routes.js`:

```js
import { mithril } from "paradiso"

mithril({ "/": "../components/home" })

module.exports = mithril
```

#### Client initializer

`app/init/client.js`:

```js
import { mithril } from "./routes"

mithril().client()
```

#### Server initializer

`app/init/server.js`: 

```js
import { express } from "paradiso"
import { mithril } from "./routes"

express({
  engine: mithril()
  port:   9000
  static: "public"
})
```

### Component

`components/home.js`:

```js
import def from "definite"

module.exports = def(class {
  then: => "hello!"
})
```

### Build assets

Build your client js assets:

```bash
node ./init/build
```

### Start server

Start the web server:

```bash
node ./init/server
```

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

This project is available in the [getting-started](https://github.com/invrs/paradiso-example/tree/getting-started) branch of the example repo.

### Components

Let's build a valid HTML page with content:

`components/home.js`:

```js
import def from "definite"

module.exports = def(class {

  then: () => {
    let content = [
      H1(this.title),
      P(`hello`)
    ]
    let title = `home`

    if this.options.server
      return this.layoutView({ content, title })
    else
      return content
  }
  
  layoutView: def(class {

    then: () =>
      HTML [
        HEAD(this.options.title)
        BODY(this.options.content)
      ]
  })
})
```

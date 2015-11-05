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

#### Build initializer

`app/init/build.js`:

```js
const ENV = process.env.NODE_ENV

class Build {
  compress() {
    if (ENV != "production") return

    return super.compress({
      css: "../public/styles",
      js:  "../public/client"
    })
  }

  package() {
    return super.package({
      css:  "../app/init/styles",
      js:   "../app/init/client",
      dest: "../public"
    })
  }

  then() {
    return this.package().then(compress())
  }
}

import paradiso from "paradiso"
export default paradiso(Build)
```

#### App initializer

`app/init/app.js`:

```js
class App {
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
}

import paradiso from "paradiso"
export default paradiso(App)
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
class Home {
  then() { return "hello!" }
}

import paradiso from "paradiso"
export default paradiso(Home)
```

### Build assets

Use the `diso` command to run your initialization classes:

```bash
diso init/client
```

(**Protip**: `diso` is just a wrapper for [the `def` command](https://github.com/invrs/definite#definite-executor))

### Start server

Start the web server:

```bash
diso init/server
```

Now you have a functioning Paradiso project up and running at [127.0.0.1:9000](http://127.0.0.1:9000).

This project is available in the [getting-started](https://github.com/invrs/paradiso-example/tree/getting-started) branch of the example repo.

### Components

Let's build a more complex HTML page with content:

`lib/component.js`:

```js
import paradiso from "paradiso"
export default paradiso({
  // Autoload dependencies
  //
  autoload: `${__dirname}/../components`
})
```

`lib/view.js`:

```js
import component from "./component"
export default component({
  // Views should never hold state
  //
  key: null
})
```

`components/layout/layout.view.js`:

```js
class LayoutView {
  then() {
    return HTML [
      HEAD(this.options.title)
      BODY(this.options.content)
    ]
  }
})

import view from "../lib/view"
export default view(LayoutView)
```

`components/home/home.js`:

```js
class Home {
  then() {
    let title = `home`
    let content = [
      H1(this.title),
      P(`hello`)
    ]

    if this.options.server
      return this.components.layout.view({ content, title })
    else
      return content
  }
}

import component from "../lib/component"
export default component(Home)
```

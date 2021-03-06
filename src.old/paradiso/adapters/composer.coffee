module.exports = class Composer
  constructor: (options) ->
    A = require("./composer/globals")(options)
    B = require("./composer/helpers")(options)
    C = require("./composer/waiter")(options)
    D = require("./composer/mithril/prop")(options)
    E = require("./composer/mithril/redraw")(options)
    F = require("./composer/mithril/sugartags")(options)
    
    if options.extensions
      G = options.extensions(options)
    else
      G = class
        constructor: -> super
        
    H = options.Component

    @Component =
      A extends
      B extends
      C extends
      D extends
      E extends
      F extends
      G extends
      H
    
  component: (options={}) ->
    new @Component options

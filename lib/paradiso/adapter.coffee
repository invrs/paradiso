module.exports =
  Component: require "./adapter/component"
  Render:
    Mithril: require "./adapter/render/mithril"
  Server:
    Express: require "./adapter/server/express"

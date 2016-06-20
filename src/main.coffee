express = require 'express'
path = require 'path'

module.exports =
  backend: ({app}) ->
    # setup handlebars
    exphbrs = require 'express-handlebars'
    app.set('views', path.resolve(__dirname, '..', 'views'))
    app.engine('handlebars', exphbrs({
      defaultLayout: 'main'
      partialsDir: app.get('views')
      layoutsDir: path.resolve(app.get('views'), 'layouts')
    }))

    app.locals.lteScripts = []
    app.locals.lteStyles  = []

    # unless app.locals.context
    #   app.locals.context = {app.locals.lteScripts}

    exphbrs.ExpressHandlebars::_renderTemplate = (template, context, options) ->
      #context.lteApps = app.locals.apps
      context.baseURL = 'http://localhost:3001'

      if app.locals.context
        for key,value of app.locals.context
          context[key] = value

      #context.lteScripts = app.locals.lteScripts
      #context.lteStyles  = app.locals.lteStyles
      context.assets     = context.baseURL

      template(context, options)

    app.set('view engine', 'handlebars')

    # app is rendered into root path
    app.get '/', (req, res) ->
      res.status(200).render('app')

    getModuleDir = (mod) ->
      require.resolve(mod).match(/^(.*\/node_modules\/[^\/]+)/)[1]

    admin_lte_dir = getModuleDir('admin-lte')

    # for jquery, jquery-ui, etc
    pkgdirs = []
    for mod in [ 'jquery', 'jquery-ui-bundle', 'webcomponents.js', 'admin-lte',
      'moment', 'raphael' ]
      dir = path.resolve(getModuleDir(mod), '..')
      pkgdirs.push(dir) if dir not in pkgdirs

    for dir in pkgdirs
      app.use(express.static(dir))

    # for bootstrap
    app.use(express.static(admin_lte_dir))

  frontend: path.resolve __dirname, "frontend.coffee"

"use strict"

http = require("http")
path = require("path")

express = require("express")
passport = require("passport")

logger = require("./lib/logger")
api = require("./lib/api")
routes = require("./lib/routes")

app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.engine 'html', require('ejs').renderFile
app.set 'view engine', 'html'
app.enable 'trust proxy'

app.use express.logger(stream: {write: (msg, encode) -> logger.info(msg)})
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()

# development only
if "development" is app.get("env")
  app.use express.static(path.join(__dirname, ".tmp"))
  app.use express.static(path.join(__dirname, "app"))
  app.use express.errorHandler()
  app.set 'views', path.join(__dirname, "app")

# production only
else
  app.use express.favicon(path.join(__dirname, "public/favicon.ico"))
  app.use express.static(path.join(__dirname, "public"))
  app.set 'views', path.join(__dirname, "public")

app.use (err, req, res, next) ->
  logger.error "#{err}"
  next(err)

app.use express.cookieSession(
  secret: process.env.COOKIE_SECRET || "f67a2c22-a2f8-4eef-8e8f-a18d07d304f7"
)
app.use passport.initialize()
app.use passport.session()
app.use api.setup()
app.use (req, res, next) ->  # disable cache for api
  if req.path.search(/\/api\//) is 0
    res.set 'Cache-Control', 'no-cache'
  next()
app.use app.router # api router

app.get "/api/awesomeThings", api.awesomeThings

app.get "/api/devices", api.devices.list
app.get "/api/devices/:id", api.devices.get
app.post "/api/devices", api.devices.create
app.post "/api/devices/:id", api.devices.update
app.delete "/api/devices/:id", api.devices.delete

app.get "/api/issues", api.issues.list
app.get "/api/issues/:id", api.issues.get
app.post "/api/issues", api.issues.create
app.delete "/api/issues/:id", api.issues.delete

app.get "/api/posts", api.posts.list
app.get "/api/posts/:id", api.posts.get
app.post "/api/posts", api.posts.create
app.post "/api/posts/:id", api.posts.update
app.delete "/api/posts/:id", api.posts.delete

app.all "/api/*", (req, res) -> res.json 404, error: "API Not Found."

app.get '/views/*', routes.views
app.get '/*', (req, res) ->
  res.sendfile path.join(__dirname, "#{if 'development' is app.get('env') then 'app' else 'public'}/index.html")

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port #{app.get('port')} in #{app.get('env')} mode."

/* jshint node: true */
"use strict";

var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var db = require('./models');
var fs = require('fs');

var routes = require('./routes/index');

var RequestController = require('./controllers/RequestController');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
require('./controllers/TemplatingEngineController')(app);

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: false
}));
app.use(cookieParser());

app.use(express.static(path.join(__dirname, 'public')));

// Sessions
var session = require('express-session');
var SequelizeStore = require('connect-session-sequelize')(session.Store);
var secret = process.env.SESSION_KEY;
if (!secret) {
    throw new Error("No session secret specified in environment variables.");
}
app.use(session({
    secret: secret,
    store: new SequelizeStore({
        db: db.sequelize
    }),
    resave: false,
    saveUninitialized: true,
    cookie: {
        secure: true
    }
}));

// Logging:
require('./controllers/LoggingController')(app);

app.use('/', routes);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers
app.use(function(result, req, res, next) {
    return RequestController.error(req, res, result);
});

module.exports = app;
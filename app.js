/*!
 * combine system by node - app.js
 */
var path = require('path');
var express = require('express');
var routes = require('./routes');
var conf = require('./conf');
var MongoStore = require('connect-mongo')(express);
//var ndir = require('ndir');
//var config = require('./config').config;

var app = express();
app.use(express.bodyParser());


app.configure(function(){
  	app.set('port', 1426);
  	app.set('views', __dirname + '/view');
  	app.engine('html', require('ejs').renderFile);
  	app.use(express.cookieParser());
	app.use(express.session({
		secret: conf.cookieSecret, 
		store: new MongoStore({ 
			db: conf.db 
		})
	}));
  	app.use(app.router);
  	
  	app.use(express.static(path.join(__dirname, 'public')));
});

app.listen(app.get('port'));

// routes
routes(app);
//module.exports = app;

console.log("Server Start!");
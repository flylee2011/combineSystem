/*!
 * combine system by node - app.js
 */
var path = require('path');
var express = require('express');
var routes = require('./routes');
//var ndir = require('ndir');
//var config = require('./config').config;

var app = express();

app.configure(function(){
  	app.set('port', 1426);
  	app.set('views', __dirname + '/view');
  	app.engine('html', require('ejs').renderFile);
  	app.use(app.router);
  	//app.set('view engine', 'ejs');
  	
  	app.use(express.static(path.join(__dirname, 'public')));
});

app.listen(app.get('port'));

// routes
routes(app);
//module.exports = app;

console.log("hello");
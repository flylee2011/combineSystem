var conf = require('../conf');
var Db = require('mongodb').Db;
var Connection = require('mongodb').Connection;
var Server = require('mongodb').Server;

module.exports = new Db(conf.db, new Server(conf.host, Connection.DEFAULT_PORT, {}));

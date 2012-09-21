
var site = require('./controllers/site');

module.exports = function (app) {
	// home page
	app.get('/', site.home);
	app.post('/combine', site.combine);
};
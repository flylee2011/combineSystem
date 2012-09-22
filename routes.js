
var site = require('./controllers/site');

module.exports = function (app) {
	// home page
	app.get('/', site.home);
	app.get('/login', site.login);
	app.post('/combine', site.combine);
	app.get('/api/getCombineInfo', site.getCombineInfo);
};
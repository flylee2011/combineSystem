
var site = require('./controllers/site');


module.exports = function (app) {
	// home page
	app.get('/',checklogin);
	app.get('/', site.home);
	app.get('/login', site.login);
	app.get('/logout', site.logout);
	app.post('/login', site.doLogin);
	app.post('/combinejs', site.combinejs);
	app.post('/combinecss', site.combinecss);
	app.get('/api/getCombineInfo', site.getCombineInfo);
	app.get('/api/getCombineCSSInfo', site.getCombineCSSInfo);

	function checklogin(req, res, next){
		if (!req.session.user) {
			//req.flash('error', '未登入');
			return res.redirect('/login');
		}
		next();
	}
};
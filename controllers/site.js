var User = require('../models/user');
var user_obj = {};

exports.home = function(req, res, next) {
	user_obj = req.session.user;
	res.render('index.html', {
		username : req.session.user.username
	});
};

exports.login = function(req, res, next) {
	res.render('login.html');
};

exports.logout = function(req, res, next){
	req.session.user = null;
     res.redirect('/');
}

exports.doLogin = function(req, res, next){
	var postData = req.body;

	User.get(postData.username, function(err, user){
		if(!user){
			console.log("no user");
			return res.redirect('/login');
		}
		if(user.password != postData.password){
			console.log("password error");
			return res.redirect('/login');
		}
		req.session.user = user;
		user_obj = user;
		console.log("login succ");
		res.redirect('/');
	});
	
	console.log(postData);
}

//
exports.getCombineInfo = function(req, res){
	var fs = require('fs');
	var result = fs.readFileSync('shell/'+ user_obj.username +'_js.log', 'utf8');
	res.send(result);
}

exports.getCombineCSSInfo = function(req, res){
	var fs = require('fs');
	var result = fs.readFileSync('shell/'+ user_obj.username +'_css.log', 'utf8');
	res.send(result);
}

//
exports.combinejs = function (req, res, next) {
	console.log(req.param('type'));
	var exec = require('child_process').exec, child;
	
	var postData = req.body;
	var buildnum;
	var cmd_str;

	// User.get(req.session.username, function(err, user){
	// 	buildnum = user.buildnum + 1;
	// 	console.log(buildnum);
	// });
	if(postData.increment === undefined){
		postData.increment = "0";
	}

	cmd_str = "bash shell/combine.sh -t "+ postData.svnpath +" -p "+ postData.proname 
		+" -i "+ postData.increment +" -m "+ postData.machineip + " -a " + postData.svnuser
		+" -b "+ postData.svnpass + " -u " + req.session.user.username +" 1>shell/"+ req.session.user.username +"_js.log";

	res.render('combineprocess.html', {
		username : req.session.user.username,
		type : "JS"
	});
	// console.log(postData);
	// console.log(postData.increment);
	console.log(cmd_str);
	// console.log(req.session.user.username);

	child = exec(cmd_str, function(error, stdout, stderr){
		console.log(error);
	});
	
};

//
exports.combinecss = function (req, res, next) {
	var exec = require('child_process').exec, child;
	var postData = req.body;
	var cmd_str;

	if(postData.increment === undefined){
		postData.increment = "0";
	}

	cmd_str = "bash shell/combinecss.sh -t "+ postData.svnpath +" -p "+ postData.proname 
		+" -i "+ postData.increment +" -m "+ postData.machineip + " -a " + postData.svnuser
		+" -b "+ postData.svnpass + " -u " + req.session.user.username +" 1>shell/"+ req.session.user.username +"_css.log";

	res.render('combineprocess.html', {
		username : req.session.user.username,
		type : "CSS"
	});
	
	console.log(cmd_str);

	child = exec(cmd_str, function(error, stdout, stderr){
		console.log(error);
	});
	
};

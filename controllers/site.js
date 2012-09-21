
exports.home = function (req, res, next) {
	//res.send("hahah");
	res.render('index.html');
};

exports.combine = function (req, res, next) {
	

	var exec = require('child_process').exec, child;
	var spawn = require('child_process').spawn,
    	ping  = spawn('ping', ['www.baidu.com']);

    var resData = "";
	//req.setEncoding("utf8");
    
    ping.stdout.on('data', function (data) {
    	resData += data;
    	console.log(data);
  		//res.send(resData);
	});
	ping.stderr.on('data', function (data) {
	    console.log('stderr: ' + data);
	});

	ping.on('exit', function (code) {
	    //console.log('child process exited with code ' + code);
	    res.render('combineprocess.html', {stdout: resData});
	    //res.write(resData, "utf8");
	});

	// child = exec('ping www.baidu.com',
	// 	function (error, stdout, stderr) {
	// 	    console.log('stdout: ' + stdout);
	// 	    //res.send(stdout);
	// 	    //console.log('stderr: ' + stderr);
	// 	    res.render("combineprocess.html",{stdout : stdout});
	// 	    if (error !== null) {
	// 	      console.log('exec error: ' + error);
	// 		}
	// });
};

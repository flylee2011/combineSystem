function jsformcheck() {
	var svnpath1 = $("#svnpath1").val(),
		svnuser1 = $("#svnuser1").val(),
		svnpass1 = $("#svnpass1").val(),
		proname1 = $('#selectPro1').val();
	// var reg = /ria\/[a-z]+\//g;
	// var proname = reg.exec(svnpath1);
	var path_arr = svnpath1.split("/"),
		len = path_arr.length,
		proname = path_arr[len-3];
	
	

	if(svnpath1 === ""){
		alert("svn地址不能为空！");
		return false;
	}
	if(svnuser1 === ""){
		alert("svn用户名不能为空！");
		return false;
	}
	if(svnpass1 === ""){
		alert("svn密码不能为空！");
		return false;
	}

	if(proname != proname1){
		alert("svn路径和工程名不符，请重新选择工程名！");
		return false;
	}
	return true;
}

function cssformcheck() {
	var svnpath2 = $("#svnpath2").val(),
		svnuser2 = $("#svnuser2").val(),
		svnpass2 = $("#svnpass2").val(),
		proname2 = $('#selectPro2').val();

	var path_arr = svnpath2.split("/"),
		len = path_arr.length,
		proname = path_arr[len-3];
	
	if(svnpath2 === ""){
		alert("svn地址不能为空！");
		return false;
	}
	if(svnuser2 === ""){
		alert("svn用户名不能为空！");
		return false;
	}
	if(svnpass2 === ""){
		alert("svn密码不能为空！");
		return false;
	}

	if(proname != proname2){
		alert("svn路径和工程名不符，请重新选择工程名！");
		return false;
	}
	
	return true;
}

function setStorage() {
	if(window.localStorage) {
		var storage = window.localStorage;
		//console.log('This browser supports localStorage');

		var jsdata = {
			"svnuser": $("#svnuser1").val(), 
			"svnpass": $("#svnpass1").val(),
			"svnpath": $("#svnpath1").val(),
			"ip": $("#machineip1").val(),
			"proname": $("#selectPro1").val()
		};
		var cssdata = {
			"svnuser": $("#svnuser2").val(), 
			"svnpass": $("#svnpass2").val(),
			"svnpath": $("#svnpath2").val(),
			"ip": $("#machineip2").val(),
			"proname": $("#selectPro2").val()
		};

		storage.setItem("svnuser1", jsdata.svnuser);
		storage.setItem("svnpass1", jsdata.svnpass);
		storage.setItem("svnpath1", jsdata.svnpath);
		storage.setItem("machineip1", jsdata.ip);
		storage.setItem("proname1", jsdata.proname);

		storage.setItem("svnuser2", cssdata.svnuser);		
		storage.setItem("svnpass2", cssdata.svnpass);		
		storage.setItem("svnpath2", cssdata.svnpath);
		storage.setItem("machineip2", cssdata.ip);
		storage.setItem("proname2", cssdata.proname);

	}else {
		console.log('This browser does NOT support localStorage');
	}
}

function getStorage() {
	if(window.localStorage) {
		var storage = window.localStorage;
		$("#svnuser1").val(storage.getItem("svnuser1"));
		$("#svnpass1").val(storage.getItem("svnpass1"));
		$("#svnpath1").val(storage.getItem("svnpath1"));

		$("#svnuser2").val(storage.getItem("svnuser2"));	
		$("#svnpass2").val(storage.getItem("svnpass2"));
		$("#svnpath2").val(storage.getItem("svnpath2"));

		var ip1 = storage.getItem("machineip1");
		var ip2 = storage.getItem("machineip2");
		var proname1 = storage.getItem("proname1");
		var proname2 = storage.getItem("proname2");
		
		$("#machineip1 option[value='"+ ip1 +"']").attr("selected", true);
		$("#machineip2 option[value='"+ ip2 +"']").attr("selected", true);
		$("#selectPro1 option[value='"+ proname1 +"']").attr("selected", true);
		$("#selectPro2 option[value='"+ proname2 +"']").attr("selected", true);

	}else {
		console.log('This browser does NOT support localStorage');
	}
}

getStorage();

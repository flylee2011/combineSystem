var mongodb = require('./db');

function User(user) {
	this.username = user.username;
	this.password = user.password;
	this.buildnum = user.buildnum;
};

module.exports = User;

User.prototype.save = function save(callback) {
	// 
	var user = {
		username : this.username,
		password : this.password,
		buildnum : this.buildnum
	};
	mongodb.open(function(err, db){
		if(err){
			return callback(err);
		}

		db.collection('user', function(err, collection){
			if(err){
				mongodb.close();
				return callback(err);
			}
			collection.ensureIndex('username', {unique: true});
			collection.insert(user, {safe: true}, function(err, user){
				mongodb.close();
				callback(err, user);
			});
		});
	})
};

User.get = function get(username, callback){
	mongodb.open(function(err, db){
		if(err){
			return callback(err);
		}
		//read user collection
		db.collection('user', function(err, collection){
			if(err){
				return callback(err);
			}
			collection.findOne({username: username}, function(err, doc){
				mongodb.close();
				if(doc){
					var user = new User(doc);
					callback(err, user);
				}else{
					callback(err, null);
				}
			});
		});
	});
};



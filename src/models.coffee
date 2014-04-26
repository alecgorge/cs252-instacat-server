Sequelize 		= require 'sequelize'
bcrypt 	 		= require 'bcryptjs'

config 			= require './config'

db				= new Sequelize 'notused', 'notused', 'notused',
						dialect: 'sqlite'
						storage: 'data/instacat.sqlite3'
						logging: console.log

remove_keys = (obj, keys...) ->
	for key in ['id', 'updatedAt'].concat(keys)
		delete obj[key]

	return obj

User = db.define 'User', 
	name 	: type: Sequelize.STRING(50), validate: len: [1, 50]
	handle 	: type: Sequelize.STRING(16), validate: len: [1, 16]
	hash 	: Sequelize.STRING(60)
,
	instanceMethods :
		checkPassword : (password, cb) ->
			bcrypt.compare password, @hash, cb
		toJSON: () -> remove_keys @values, 'hash'
	classMethods :
		hashPassword : (password, cb) ->
			bcrypt.hash password, 8, (err, hash) -> cb err, hash

Image = db.define 'Image',
	# example: 110ec58a-a0f2-4ac4-8393-c866d813b8d1
	uuid 	: type: Sequelize.STRING(36), unique: true
,
	instanceMethods :
		toJSON: () -> remove_keys @values, 'UserId'

# {} needed to ensure NULL isn't passed
Like = db.define 'Like', {

},
	instanceMethods :
		toJSON: () -> remove_keys @values, 'UserId', 'ImageId'

Comment = db.define 'Comment',
	text 	: Sequelize.TEXT
,
	instanceMethods :
		toJSON: () -> remove_keys @values, 'UserId', 'ImageId'

Like.belongsTo User
Like.belongsTo Image

Comment.belongsTo User
Comment.belongsTo Image

Image.hasMany Like
Image.hasMany Comment
Image.belongsTo User

User.hasMany Image
User.hasMany Comment
User.hasMany Like

# uncomment to resync db structure
# db.sync force: true

module.exports =
	User 		: User
	Image 		: Image
	Like 		: Like
	Comment 	: Comment
	Sequelize 	: Sequelize
	QueryChainer: Sequelize.Utils.QueryChainer

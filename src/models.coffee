Sequelize 		= require 'sequelize'
bcrypt 	 		= require 'bcrypt'

config 			= require './config'

db				= new Sequelize 'notused', 'notused', 'notused',
						dialect: 'sqlite'
						storage: 'data/instacat.sqlite3'
						logging: console.log

User = db.define 'User', 
	name 	: type: Sequelize.STRING(50), validate: len: [1, 50]
	handle 	: type: Sequelize.STRING(16), validate: len: [1, 16]
	hash 	: Sequelize.STRING(60)
,
	instanceMethods :
		checkPassword : (password, cb) ->
			bcrypt.compare password, @hash, cb
	classMethods :
		hashPassword : (password, cb) ->
			console.log password
			bcrypt.hash password, 8, (err, hash) -> cb err, hash

Image = db.define 'Image',
	# example: 110ec58a-a0f2-4ac4-8393-c866d813b8d1
	uuid 	: type: Sequelize.STRING(36), unique: true

# {} needed to ensure NULL isn't passed
Like = db.define 'Like', {}

Comment = db.define 'Comment',
	text 	: Sequelize.TEXT

Like.belongsTo User
Like.belongsTo Image

Comment.belongsTo User
Comment.belongsTo Image

Image.hasMany Like
Image.hasMany Comment

User.hasMany Comment
User.hasMany Like

# uncomment to resync db structure
# db.sync force: true

module.exports =
	User 		: User
	Image 		: Image
	Like 		: Like
	Comment 	: Comment

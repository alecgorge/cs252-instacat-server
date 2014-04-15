Sequelize 		= require 'sequelize'
db				= new Sequelize dialect: 'sqlite', storage: 'data/instacat.sqlite3'

User = db.define 'User', 
	name 	: Sequelize.STRING(50)
	handle 	: Sequelize.STRING(16)
	hash 	: Sequelize.STRING(60)

Image = db.define 'Image',
	# example: 110ec58a-a0f2-4ac4-8393-c866d813b8d1
	uuid 	: type: Sequelize.STRING(36), unique: true

Like = db.define 'Like'

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

module.exports =
	User 		: User
	Image 		: Image
	Like 		: Like
	Comment 	: Comment

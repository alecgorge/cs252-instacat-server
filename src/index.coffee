express 		= require 'express'
passport 		= require 'passport'
logger 			= require 'morgan'
body_parser 	= require 'body-parser'
multipart 	 	= require 'connect-multiparty'

models 			= require './models'
config 			= require './config'
auth 			= require './auth'

c_users 		= require './controllers/users'
c_images 		= require './controllers/images'

app 			= express()
auth 			= passport.authenticate 'basic', session: false

app.use logger 'dev'
app.use body_parser()
app.use multipart()
app.use require('errorhandler')(showStack: true, dumpExceptions: true)

# unprotected routes
app.post '/api/users/new', 							c_users.users_new
app.get  '/api/users/:handle', 						c_users.user
app.post '/api/images/', 							c_images.images
app.get  '/api/images/:image_uuid', 				c_images.image
app.get  '/api/images/:image_uuid.jpg', 			c_images.image_jpg

# protected routes
app.post '/api/images/new', 				auth, 	c_images.upload_image
app.post '/api/images/:image_uuid/like', 	auth, 	c_images.like_image
app.post '/api/images/:image_uuid/comment', auth, 	c_images.comment_image

app.listen config.env().port
console.log "Listening on port #{config.env().port}"

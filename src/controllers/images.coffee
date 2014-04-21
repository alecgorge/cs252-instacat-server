uuidgen 	= require 'node-uuid'
fs 			= require 'fs'

models 		= require '../models'

rerr = (res) ->
	return (err) ->
		throw err if err

module.exports.images = (req, res) ->
	last_visible_uuid = req.param 'starting_at'

module.exports.image = (req, res) ->
	uuid = req.param 'image_uuid'

	models.Image.find where: uuid: uuid
		.error rerr(res)
		.success (img) ->
			if img is null
				return res.send 404, 'User does not exist'

			#I'm assuming you might want me to return some user data as well? 
			res.json uuid: img.uuid, createdAt: img.createdAt 
			
module.exports.image_jpg = (req, res) ->
	uuid = req.param 'image_uuid'
	filePath = _dirname + "/../../user_images" + uuid + ".jpg"

	#TODO properly set the image into the response

module.exports.upload_image = (req, res) ->
	image = req.files.image
	user = req.user
	uuid = uuidgen.v4()

	# add image to database
	models.Image.find where: uuid: uuid
		.error rerr(res)
		.success (img) ->
			if img
				uuid= uuidgen.v4()

			newimg = models.Image.build
				uuid: uuid


			errors = newimg.validate()

			newimg.save()
				.success ->
					newimg.setUser(user)
						.success ->
							fs.readFile image.path, (err, data) ->
								newPath = __dirname + "/../../user_images/" + uuid + ".jpg"
								fs.writeFile newPath, data, (err) ->
										throw err  if err
							res.send 201
						.error (errors) ->
							res.json 400,errors
					
				.error (errors) ->
					res.json 400, errors

module.exports.like_image = (req, res) ->
	uuid = req.param 'image_uuid'
	user = req.user


	#do a join on the Users, Images, and Likes tables (ask Alec for syntax)
		.error rerr(res)
		.success (like) ->
			if like
				res.send 409
				return

			newlike = models.Like.build

			errors = newlike.validate()

			newlike.save()
				.success ->
					newlike.setUser(user)
						.success ->
							newlike.setImage(uuid)
								.success ->
									res.send 201
								.error (errors) ->
									res.json 400,errors
						.error (errors) ->
							res.json 400,errors
				.error (errors) ->
					res.json 400,errors

module.exports.comment_image = (req, res) ->
	uuid = req.param 'image_uuid'
	comment = req.param 'comment'
	user = req.user

	#do a join on the Users, Images, and Comments tables (ask Alec for syntax)
		.error rerr(res)
		.success (commentret) ->
			if commentret
				res.send 409
				return

			newcomment = models.Comment.build
				text: comment
			errors = newcomment.validate()
				

			newcomment.save()
				.success ->
					newcomment.setUser(user)
						.success ->
							newcomment.setImage(uuid)
								.success ->
									res.send 201
								.error (errors) ->
									res.json 400,errors
						.error (errors) ->
							res.json 400,errors
				.error (errors) ->
					res.json 400,errors
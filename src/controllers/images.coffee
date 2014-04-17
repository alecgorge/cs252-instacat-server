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

module.exports.image_jpg = (req, res) ->
	uuid = req.param 'image_uuid'

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

module.exports.comment_image = (req, res) ->
	uuid = req.param 'image_uuid'
	comment = req.param 'comment'

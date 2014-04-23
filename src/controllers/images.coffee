uuidgen 	= require 'node-uuid'
fs 			= require 'fs'

models 		= require '../models'

rerr = (res) ->
	return (err) ->
		throw err if err

#can I just do this through multiple calls to .image, if so how?
module.exports.images = (req, res) ->
	last_visible_uuid = req.param 'starting_at'

#the ......s have syntax questions
module.exports.image = (req, res) ->
	uuid = req.param 'image_uuid'

	#how do I do multiple includes?
	models.Image.find where: {uuid: uuid}, include: [models.Like] .......
		.error rerr(res)
		.success (img) ->
			if img is null
				return res.send 404, 'Image does not exist'

			#okay so is this in a callback hell or can I do the jsons seperately (aka what the hell is a json??) Or maybe you want me to look up that ??? named thing that
			#is supposed to help me with not having callback hell or whatever?
			image.getLikes()
				.error rerr(res)
				.success (likes) ->
					for (like in likes)
						res.json ......

			image.getComments()
				.error rerr(res)
				.success (comments) ->
					for (comment in comments)
						res.json .........

			image.getUser()
				.error rerr(res)
				.success (user) ->
					..........

			res.json uuid: img.uuid, createdAt: img.createdAt 
			
module.exports.image_jpg = (req, res) ->
	uuid = req.param 'image_uuid'
	filePath = _dirname + "/../../user_images/" + uuid + ".jpg"

	fs.open (filePath, 'r', (err, fd) ->
  		if err
    		next()
  		else
    		fs.close fd
    		res.sendfile (filePath)

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

	#read over this callback hell and make sure it's right. I'll reformat it later as long as I know it works
	models.Image.find where: {uuid: uuid}, include: [ models.Like ]
		.error rerr(res)
		.success (image) ->
			image.getLikes()
				.error rerr(res)
				.success (likes) ->
					models.Like.find where: {UserId: user.id}
						.error rerr(res)
						.success (like) ->
							for (storedLike in likes)
								if storedLike == like
									res.send 409
									return

							newlike = models.Like.build

							errors = newlike.validate()

							newlike.save()
								.success ->
									newlike.setUser(user)
										.success ->
											newlike.setImage(image)
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

	models.Image.find where: {uuid: uuid}, include: [ models.Comment ]
		.error rerr(res)
		.success (image) ->
			image.getComments()
				.error rerr(res)
				.success (comments) ->
					models.Comment.find where: {UserId: user.id}
						.error rerr(res)
						.success (commentret) ->
							for (storedComment in comments)
								if storedComment == commentret
									res.send 409
									return

							newcomment = models.Comment.build
								text: comment
							errors = newcomment.validate()
								

							newcomment.save()
								.success ->
									newcomment.setUser(user)
										.success ->
											newcomment.setImage(image)
												.success ->
													res.send 201
												.error (errors) ->
													res.json 400,errors
										.error (errors) ->
											res.json 400,errors
								.error (errors) ->
									res.json 400,errors
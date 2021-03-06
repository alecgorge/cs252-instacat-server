uuidgen 	= require 'node-uuid'
fs 			= require 'fs'
path		= require 'path'

models 		= require '../models'

rerr = (res) ->
	return (err) ->
		throw err if err

clean_img_json = (json) ->
	json.likes = json.likes.map (v) -> { handle: v.user.handle, createdAt: v.createdAt }
	json.comments = json.comments.map (v) -> { text: v.text, handle: v.user.handle, createdAt: v.createdAt } 

	return json

module.exports.images = (req, res) ->
	last_visible_uuid = req.param 'starting_at'

	models.Image.findAll({
		include: [
			{
				model: models.Like
				include: [ models.User ]
			},
			{
				model: models.Comment
				include: [ models.User ]
				order: 'createdAt DESC'
			},
			{
				model: models.User
			}
		]
		order: 'createdAt DESC'
	})
		.error(rerr(res))
		.success (imgs) ->
			res.json imgs.map (v) -> clean_img_json v.toJSON()

module.exports.image = (req, res) ->
	uuid = req.param 'image_uuid'

	models.Image.find(
		where: uuid: uuid
		include: [
			{
				model: models.Like
				include: [ models.User ]
			},
			{
				model: models.Comment
				include: [ models.User ]
				order: 'createdAt DESC'
			},
			{
				model: models.User
			}
		]
	)
		.error rerr(res)
		.success (img) ->
			if img is null
				return res.send 404, 'Image does not exist'

			res.json clean_img_json img.toJSON()
			
module.exports.image_jpg = (req, res) ->
	uuid = req.param 'image_uuid'
	filePath = path.resolve __dirname + "/../../user_images/" + uuid + ".jpg"

	fs.exists filePath, (exists) ->
		if exists
			res.sendfile filePath
		else
			res.send 404, 'Not found'

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

			newimg = models.Image.create uuid: uuid
				.error rerr(res)
				.success (newimg) ->
					newimg.setUser user
						.error rerr(res)
						.success (results) ->
							newPath = __dirname + "/../../user_images/" + uuid + ".jpg"

							readStream = fs.createReadStream image.path
							readStream.on 'error', rerr(res)

							writeStream = fs.createWriteStream newPath
							writeStream.on 'error', rerr(res)
							writeStream.on 'close', -> 
								fs.unlink image.path, (err) ->
  									throw err if err
								res.send 201, created: true

							readStream.pipe writeStream

							

module.exports.like_image = (req, res) ->
	uuid = req.param 'image_uuid'
	user = req.user

	models.Image.find where: {uuid: uuid}
		.error rerr(res)
		.success (image) ->
			models.Like.findOrCreate({ ImageId: image.id, UserId: user.id }, {})
				.error rerr(res)
				.success (like, created) ->
					if not created
						return res.send 201, created: true

					ch = new models.QueryChainer
					
					ch.add like.setUser user
					  .add like.setImage image
					  .add image.addLike like
					  .run()
					  .error rerr(res)
					  .success ->
					  	res.send 201, created: true

module.exports.comment_image = (req, res) ->
	uuid = req.param 'image_uuid'
	txt_comment = req.param 'comment'
	user = req.user

	models.Image.find where: {uuid: uuid}
		.error rerr(res)
		.success (image) ->
			models.Comment.create { text: txt_comment }
				.error rerr(res)
				.success (comment) ->
					ch = new models.QueryChainer
					
					ch.add comment.setUser user
					  .add comment.setImage image
					  .add image.addComment comment
					  .run()
					  .error rerr(res)
					  .success ->
					  	res.send 201, created: true

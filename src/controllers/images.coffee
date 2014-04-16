models = require '../models'

module.exports.images = (req, res) ->
	last_visible_uuid = req.param 'starting_at'

module.exports.image = (req, res) ->
	uuid = req.param 'image_uuid'

module.exports.image_jpg = (req, res) ->
	uuid = req.param 'image_uuid'

module.exports.upload_image = (req, res) ->
	image = req.files.image

module.exports.like_image = (req, res) ->
	uuid = req.param 'image_uuid'

module.exports.comment_image = (req, res) ->
	uuid = req.param 'image_uuid'
	comment = req.param 'comment'

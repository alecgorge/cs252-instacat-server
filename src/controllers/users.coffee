models = require '../models'

rerr = (res) ->
	return (err) ->
		throw err if err

module.exports.users_new = (req, res) ->
	handle 	= req.param 'handle'
	name 	= req.param 'name'
	pass 	= req.param 'password'

	models.User.find where: handle: handle
		.error rerr(res)
		.success (user) ->
			if user
				res.send 409
				return

			newu = models.User.build
				handle 	: handle
				name 	: name

			models.User.hashPassword pass, (err, hash) ->
				throw err if err

				newu.hash = hash

				errors = newu.validate()

				newu.save()
				    .success ->
				    	res.send 201
				    .error (errors) ->
				    	res.json 400, errors

module.exports.user = (req, res) ->
	handle = req.param 'handle'

	models.User.find where: handle: handle
		.error rerr(res)
		.success (user) ->
			res.json name: user.name, handle: user.handle, createdAt: user.createdAt


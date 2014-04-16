passport 		= require 'passport'
passport_http 	= require 'passport-http'

models 			= require './models'

auth = (u, p, done) ->
	models.User.findOne(where: username: u).success (err, user) ->
		return done(err) if err

		user.checkPassword p, (err, valid) ->
			return done(err) if err

			if valid
				done null, user
			else
				done null, false

passport.use new passport_http.BasicStrategy auth

module.exports = auth

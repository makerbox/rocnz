class UserMailer < ApplicationMailer
	default from:'web@roccloudy.com'

	def welcome_email(user)
		@user = user
		mail(to: @user, subject: 'Welcome to RocCloudy')
	end
end

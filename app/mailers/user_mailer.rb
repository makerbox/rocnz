class UserMailer < ApplicationMailer
	default from:'mattwerth@mattwerth.com'

	def welcome_email(user)
		@user = user
		mail(to: @user, subject: 'Welcome to RocCloudy')
	end
end

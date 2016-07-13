class AdminMailer < ApplicationMailer
	default from:'mattwerth@mattwerth.com'
	def new_user_waiting_for_approval(emails)
		@emails = emails
		mail(to: @emails, subject: 'Pending Approval - RocCloudy')
	end
end

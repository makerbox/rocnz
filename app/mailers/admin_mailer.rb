class AdminMailer < ApplicationMailer
	default from:'web@roccloudy.com'
	
	def new_user_waiting_for_approval(emails)
		@emails = emails
		mail(to: 'cheryl@roccloudy.com, web@roccloudy.com', subject: 'Pending Approval - RocCloudy')
	end
end

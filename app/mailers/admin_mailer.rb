class AdminMailer < ApplicationMailer
	default from:'web@roccloudy.com'
	
	def new_user_waiting_for_approval(email, account)
		@account = account
		mail(to: email, subject: 'Pending Approval - RocCloudy')
	end
end

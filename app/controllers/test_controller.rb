class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
    @results = []
    # Account.all.each do |a|
    # 	@results << a.sort << '-------' << a.company
    # end
		def createrep(repemail, repcode)
      if repuser = User.all.find_by(email: repemail)
        repuser.add_role :rep
        repuser.remove_role :user
        if repuser.account
          repuser.account.update_attributes(approved: 'approved', sort: 'U/L/R/P')
        else
          Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
        end
      else
        repuser = User.new(email: repemail, password:'cloudy_16', password_confirmation: 'cloudy_16')
        repuser.add_role :rep
        repuser.save(validate: false)
        Account.create(code: repcode, company: 'Roc', user: repuser, sort: 'U/L/R/P')
      end
    end

    createrep('nsw@roccloudy.com', 'REPNSW')
    createrep('vic@roccloudy.com', 'REPVIC')
    createrep('qld1@roccloudy.com', 'REPQLD1')
    createrep('qld2@roccloudy.com', 'REPQLD2')
    createrep('nz@roccloudy.com', 'REPNZ')
    createrep('office@roccloudy.com', 'ADMINOFFICE')
	end

end
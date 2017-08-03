class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       @results = Discount.all.where(product: ('PM'), customer: (current_user.mimic.account.code.strip || current_user.mimic.account.discount))
end
end
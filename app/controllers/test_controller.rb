class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
       discos = Discount.all.where(product: ('PM'), customer: (current_user.mimic.account.code.strip || current_user.mimic.account.discount))
       @results = discos.where('maxqty >= ?', 1).first
end
end
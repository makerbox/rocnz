class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(user, price, prod_group, prod_code)
	# if Discount.all.find_by(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code)
		if Discount.all.find_by(producttype: 'group_percent', product: prod_group, customertype: 'code_percent', customer: user.account.code)
			discount = Discount.all.find_by(producttype: 'group_percent', product: prod_group, customertype: 'code_percent', customer: user.account.code).discount
			# discount = (price / 100) * discount
			price - discount
		elsif Discount.all.find_by(producttype: 'group_percent', product: prod_group, customertype: 'group_percent', customer: user.account.discount)
			discount = Discount.all.find_by(producttype: 'group_percent', product: prod_group, customertype: 'group_percent', customer: user.account.discount).discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.all.find_by(producttype: 'code_percent', product: prod_code, customertype: 'code_percent', customer: user.account.code)
			discount = Discount.all.find_by(producttype: 'code_percent', product: prod_code, customertype: 'code_percent', customer: user.account.code).discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.all.find_by(producttype: 'code_percent', product: prod_code, customertype: 'group_percent', customer: user.account.discount)
			discount = Discount.all.find_by(producttype: 'code_percent', product: prod_code, customertype: 'group_percent', customer: user.account.discount).discount
			discount = (price / 100) * discount
			price - discount
	# elsif Discount.all.find_by(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code)
		elsif Discount.all.find_by(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code)
			discount = Discount.all.find_by(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code).discount
			price - discount
		elsif Discount.all.find_by(producttype: 'group_fixed', product: prod_group, customertype: 'group_fixed', customer: user.account.discount)
			discount = Discount.all.find_by(producttype: 'group_fixed', product: prod_group, customertype: 'group_fixed', customer: user.account.discount).discount
			price - discount
		elsif Discount.all.find_by(producttype: 'code_fixed', product: prod_code, customertype: 'code_fixed', customer: user.account.code)
			discount = Discount.all.find_by(producttype: 'code_fixed', product: prod_code, customertype: 'code_fixed', customer: user.account.code).discount
			price - discount
		elsif Discount.all.find_by(producttype: 'code_fixed', product: prod_code, customertype: 'group_fixed', customer: user.account.discount)
			discount = Discount.all.find_by(producttype: 'code_fixed', product: prod_code, customertype: 'group_fixed', customer: user.account.discount).discount
			price - discount
		# end
		else
			price
		end
end

end #end of class

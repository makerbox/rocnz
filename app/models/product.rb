class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(user, price, prod_group, prod_code)
	# if Discount.all.where(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code)
		if Discount.all.where(producttype: 'group_percent', product: prod_group, customertype: 'code_percent', customer: user.account.code)
			disco = Discount.all.find_by(producttype: 'group_percent', product: prod_group, customertype: 'code_percent', customer: user.account.code).discount
			# disco = (price / 100) * discount
			price - disco
		elsif Discount.all.where(producttype: 'group_percent', product: prod_group, customertype: 'group_percent', customer: user.account.discount)
			disco = Discount.all.find_by(producttype: 'group_percent', product: prod_group, customertype: 'group_percent', customer: user.account.discount).discount
			disco = (price / 100) * discount
			price - disco
		elsif Discount.all.where(producttype: 'code_percent', product: prod_code, customertype: 'code_percent', customer: user.account.code)
			disco = Discount.all.find_by(producttype: 'code_percent', product: prod_code, customertype: 'code_percent', customer: user.account.code).discount
			disco = (price / 100) * discount
			price - disco
		elsif Discount.all.where(producttype: 'code_percent', product: prod_code, customertype: 'group_percent', customer: user.account.discount)
			disco = Discount.all.find_by(producttype: 'code_percent', product: prod_code, customertype: 'group_percent', customer: user.account.discount).discount
			disco = (price / 100) * discount
			price - disco
	# elsif Discount.all.where(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code)
		elsif Discount.all.where(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code)
			disco = Discount.all.find_by(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code).discount
			price - disco
		elsif Discount.all.where(producttype: 'group_fixed', product: prod_group, customertype: 'group_fixed', customer: user.account.discount)
			disco = Discount.all.find_by(producttype: 'group_fixed', product: prod_group, customertype: 'group_fixed', customer: user.account.discount).discount
			price - disco
		elsif Discount.all.where(producttype: 'code_fixed', product: prod_code, customertype: 'code_fixed', customer: user.account.code)
			disco = Discount.all.find_by(producttype: 'code_fixed', product: prod_code, customertype: 'code_fixed', customer: user.account.code).discount
			price - disco
		elsif Discount.all.where(producttype: 'code_fixed', product: prod_code, customertype: 'group_fixed', customer: user.account.discount)
			disco = Discount.all.find_by(producttype: 'code_fixed', product: prod_code, customertype: 'group_fixed', customer: user.account.discount).discount
			price - disco
		# end
		else
			price
		end
end

end #end of class

class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(user, price, prod_group, prog_code)
	# if Discount.where(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code.strip)
		if Discount.where(producttype: 'group_percent', product: prod_group, customertype: 'code_percent', customer: user.account.code.strip).exists?
			discount = Discount.where(producttype: 'group_percent', product: prod_group, customertype: 'code_percent', customer: user.account.code.strip).discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'group_percent', product: prod_group, customertype: 'group_percent', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'group_percent', product: prod_group, customertype: 'group_percent', customer: user.account.discount)[0].discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'code_percent', product: prod_code, customertype: 'code_percent', customer: user.account.code.strip).exists?
			discount = Discount.where(producttype: 'code_percent', product: prod_code, customertype: 'code_percent', customer: user.account.code.strip)[0].discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'code_percent', product: prod_code, customertype: 'group_percent', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'code_percent', product: prod_code, customertype: 'group_percent', customer: user.account.discount)[0].discount
			discount = (price / 100) * discount
			price - discount
	# elsif Discount.where(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code.strip)
		elsif Discount.where(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code.strip).exists?
			discount = Discount.where(producttype: 'group_fixed', product: prod_group, customertype: 'code_fixed', customer: user.account.code.strip)[0].discount
			price - discount
		elsif Discount.where(producttype: 'group_fixed', product: prod_group, customertype: 'group_fixed', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'group_fixed', product: prod_group, customertype: 'group_fixed', customer: user.account.discount)[0].discount
			price - discount
		elsif Discount.where(producttype: 'code_fixed', product: prod_code, customertype: 'code_fixed', customer: user.account.code.strip).exists?
			discount = Discount.where(producttype: 'code_fixed', product: prod_code, customertype: 'code_fixed', customer: user.account.code.strip)[0].discount
			price - discount
		elsif Discount.where(producttype: 'code_fixed', product: prod_code, customertype: 'group_fixed', customer: user.account.discount).exists?
			discount = Discount.where(producttype: 'code_fixed', product: prod_code, customertype: 'group_fixed', customer: user.account.discount)[0].discount
			price - discount
		# end
		else
			price
		end
end

end #end of class

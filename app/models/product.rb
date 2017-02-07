class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount(user, price)
	# if Discount.where(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code)
		if Discount.where(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code)[0].discount
			discount = Discount.where(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code)[0].discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'group_percent', product: self.group, customertype: 'group_percent', customer: user.account.discount)
			discount = Discount.where(producttype: 'group_percent', product: self.group, customertype: 'group_percent', customer: user.account.discount)[0].discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'code_percent', product: self.code, customertype: 'code_percent', customer: user.account.code)
			discount = Discount.where(producttype: 'code_percent', product: self.code, customertype: 'code_percent', customer: user.account.code)[0].discount
			discount = (price / 100) * discount
			price - discount
		elsif Discount.where(producttype: 'code_percent', product: self.code, customertype: 'group_percent', customer: user.account.discount)
			discount = Discount.where(producttype: 'code_percent', product: self.code, customertype: 'group_percent', customer: user.account.discount)[0].discount
			discount = (price / 100) * discount
			price - discount
	# elsif Discount.where(producttype: 'group_fixed', product: self.group, customertype: 'code_fixed', customer: user.account.code)
		elsif Discount.where(producttype: 'group_fixed', product: self.group, customertype: 'code_fixed', customer: user.account.code)
			discount = Discount.where(producttype: 'group_fixed', product: self.group, customertype: 'code_fixed', customer: user.account.code)[0].discount
			price - discount
		elsif Discount.where(producttype: 'group_fixed', product: self.group, customertype: 'group_fixed', customer: user.account.discount)
			discount = Discount.where(producttype: 'group_fixed', product: self.group, customertype: 'group_fixed', customer: user.account.discount)[0].discount
			price - discount
		elsif Discount.where(producttype: 'code_fixed', product: self.code, customertype: 'code_fixed', customer: user.account.code)
			discount = Discount.where(producttype: 'code_fixed', product: self.code, customertype: 'code_fixed', customer: user.account.code)[0].discount
			price - discount
		elsif Discount.where(producttype: 'code_fixed', product: self.code, customertype: 'group_fixed', customer: user.account.discount)
			discount = Discount.where(producttype: 'code_fixed', product: self.code, customertype: 'group_fixed', customer: user.account.discount)[0].discount
			price - discount
		# end
		else
			price
		end
end

end #end of class

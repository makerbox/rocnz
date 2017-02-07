class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount(user, price)
	# if Discount.find_by(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code)
		if !Discount.find_by(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code).discount.nil?
			discount = Discount.find_by(producttype: 'group_percent', product: self.group, customertype: 'code_percent', customer: user.account.code).discount
			discount = (price / 100) * discount
			price - discount
		elsif !Discount.find_by(producttype: 'group_percent', product: self.group, customertype: 'group_percent', customer: user.account.discount).discount.nil?
			discount = Discount.find_by(producttype: 'group_percent', product: self.group, customertype: 'group_percent', customer: user.account.discount).discount
			discount = (price / 100) * discount
			price - discount
		elsif !Discount.find_by(producttype: 'code_percent', product: self.code, customertype: 'code_percent', customer: user.account.code).discount.nil?
			discount = Discount.find_by(producttype: 'code_percent', product: self.code, customertype: 'code_percent', customer: user.account.code).discount
			discount = (price / 100) * discount
			price - discount
		elsif !Discount.find_by(producttype: 'code_percent', product: self.code, customertype: 'group_percent', customer: user.account.discount).discount.nil?
			discount = Discount.find_by(producttype: 'code_percent', product: self.code, customertype: 'group_percent', customer: user.account.discount).discount
			discount = (price / 100) * discount
			price - discount
	# elsif Discount.find_by(producttype: 'group_fixed', product: self.group, customertype: 'code_fixed', customer: user.account.code)
		elsif !Discount.find_by(producttype: 'group_fixed', product: self.group, customertype: 'code_fixed', customer: user.account.code).discount.nil?
			discount = Discount.find_by(producttype: 'group_fixed', product: self.group, customertype: 'code_fixed', customer: user.account.code).discount
			price - discount
		elsif !Discount.find_by(producttype: 'group_fixed', product: self.group, customertype: 'group_fixed', customer: user.account.discount).discount.nil?
			discount = Discount.find_by(producttype: 'group_fixed', product: self.group, customertype: 'group_fixed', customer: user.account.discount).discount
			price - discount
		elsif !Discount.find_by(producttype: 'code_fixed', product: self.code, customertype: 'code_fixed', customer: user.account.code).discount.nil?
			discount = Discount.find_by(producttype: 'code_fixed', product: self.code, customertype: 'code_fixed', customer: user.account.code).discount
			price - discount
		elsif !Discount.find_by(producttype: 'code_fixed', product: self.code, customertype: 'group_fixed', customer: user.account.discount).discount.nil?
			discount = Discount.find_by(producttype: 'code_fixed', product: self.code, customertype: 'group_fixed', customer: user.account.discount).discount
			price - discount
		# end
		else
			price
		end
end

end #end of class

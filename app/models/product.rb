class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount(user)
	if Discount.find_by(producttype: 'group', product: self.group, customertype: 'code', customer: user.account.code)
		Discount.find_by(producttype: 'group', product: self.group, customertype: 'code', customer: user.account.code)
	end
	if Discount.find_by(producttype: 'group', product: self.group, customertype: 'group', customer: user.account.discount)
		Discount.find_by(producttype: 'group', product: self.group, customertype: 'group', customer: user.account.discount)
	end
	if Discount.find_by(producttype: 'code', product: self.code, customertype: 'code', customer: user.account.code)
		Discount.find_by(producttype: 'code', product: self.code, customertype: 'code', customer: user.account.code)
	end
	if Discount.find_by(producttype: 'code', product: self.code, customertype: 'group', customer: user.account.discount)
		Discount.find_by(producttype: 'code', product: self.code, customertype: 'group', customer: user.account.discount)
	end
	# user.account.discount
	Discount.find_by(producttype: 'group', product: self.group, customertype: 'code', customer: user.account.code).discount
end

end #end of class

class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount(user)
	if disc = Discount.find_by(producttype: 'group', product: self.group)
		if (disc.customer == current_user.account.code) || (disc.customer == current_user.account.discount)
			Discount.find_by(product: self.group).discount
		end
	end
	if disc = Discount.find_by(producttype: 'code', product: self.code)
		if (disc.customer == current_user.account.code) || (disc.customer == current_user.account.discount)
			Discount.find_by(product: self.code).discount
		end
	end
end

end #end of class

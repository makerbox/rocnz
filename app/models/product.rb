class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount
	self.group
	if Discount.find_by(product: 'LC')
		Discount.find_by(product: 'LC').discount
	else
		15
	end
end

end #end of class

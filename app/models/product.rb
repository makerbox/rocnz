class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount
	if Discount.find_by(product: self.group)
		Discount.find_by(product: self.group).discount
	else
		self.group
		Discount.find_by(product: self.group)
	end
end

end #end of class

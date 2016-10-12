class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def self.disc
	d = Discount.where(product: self.group)
	if discount
		return d.discount
	end
end

end #end of class

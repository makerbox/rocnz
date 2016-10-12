class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities


if Discount.where(product: self.group)
	self.rrp = '*'
end

end #end of class

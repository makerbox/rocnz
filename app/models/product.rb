class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount
if Discount.find_by(product: self.group) != nil
	Discount.find_by(product: self.group).discount
end
end

end #end of class

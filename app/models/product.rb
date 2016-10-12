class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities
def discount(p)
  d = Discount.where(product: p.group)
  if discount
    return d.discount
  end
end

end #end of class

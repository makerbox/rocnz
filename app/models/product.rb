class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def discount
  # d = Discount.where(product: p.group)
  # if discount
    # return d.discount
  # end
  return 15
end

end #end of class

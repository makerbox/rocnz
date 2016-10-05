class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def populate

end
handle_asynchronously :populate

end

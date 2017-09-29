class Order < ActiveRecord::Base
  belongs_to :user
  has_many :quantities,  dependent: :destroy 
  has_many :products, through: :quantities
  
  def create_kfi(self)
  	puts "path etc"
  end

end

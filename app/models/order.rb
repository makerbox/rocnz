class Order < ActiveRecord::Base
  belongs_to :user
  has_many :quantities,  dependent: :destroy 
  has_many :products, through: :quantities
  
  def kfi
  	# path = self.id.to_s + self.user.account.company + ".txt"
  	# content = "this is a test for the kfi file generator"
  	# File.open(path, "w+") do |f|
  	# 	f.write(content)
  	# end
  end

end

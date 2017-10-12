class Order < ActiveRecord::Base
  belongs_to :user
  has_many :quantities,  dependent: :destroy 
  has_many :products, through: :quantities
  
  def kfi
  	filename = self.id.to_s self.id.to_s + self.user.account.company
  	path = "E:\\Attache\\Attache\\Roc\\KFIDATA\\Orders\\" + filename + ".kfi"
  	content = 'this is a test for the kfi file generator --- 
  	"#{self.user.account.company}","","","","","","","#{filename}","","#{self.order_number}","","","",""
  	'
  	File.open(path, "w+") do |f|
  		f.write(content)
  	end
  end

end

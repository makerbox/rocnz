class Order < ActiveRecord::Base
  belongs_to :user
  has_many :quantities,  dependent: :destroy 
  has_many :products, through: :quantities
  
  def kfi
  	filename = self.id.to_s + self.user.account.company
  	path = "E:\\Attache\\Attache\\ROCNZ\\KFIDATA\\Orders\\" + filename + ".kfi"
  	items = ''
  	self.quantities.each do |q|
  		product = q.product.code.to_s
  		qty = q.qty.to_s
  		items = items + '"'+product+'","'+qty+'","","","",""/r/n'
  	end
  	notes = self.notes
  	# content = '"'+self.user.account.company+'","","","","","","","'+filename+'","","'+self.order_number.to_s+'","","","",""
  	# \r\n'+items+'<F9><F4><DOWN><DOWN><DOWN><DOWN><ENTER>,"","","'+notes+'","","","","","","","","","","","","",""'
  	# File.open(path, "w+") do |f|
  	# 	f.write(content)
  	# end
  end

end

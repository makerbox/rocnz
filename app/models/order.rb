class Order < ActiveRecord::Base
  belongs_to :user
  has_many :quantities,  dependent: :destroy 
  has_many :products, through: :quantities
  
  def kfi
    filename = self.id.to_s
    path = "E:\\Attache\\Attache\\ROCNZ\\KFIDATA\\Orders\\" + filename + ".kfi"
    items = []
    self.quantities.each do |q|
      product = q.product.code.to_s
      qty = q.qty.to_s
      items << '"'+product+'","'+qty+'","","","",""'
    end
    notes = self.notes.to_s
    notes_first = notes[0..60].to_s
    notes_second = notes[60..-1].to_s
    firstline = '"'+self.user.account.company.strip+'","","","","","","","'+filename+'","","'+Date.today.strftime('%d%m%Y').to_s+'","","","",""'
    lastline = '<F9><F4><DOWN><DOWN><DOWN><DOWN><ENTER>,"","","'+notes_first+'","","'+notes_second+'","","","","","","","","","","",""'
    File.open(path, "w+") do |f|
      f.puts(firstline)
      items.each do |i|
        f.puts(i)
      end
      f.puts(lastline)
    end
  end



end

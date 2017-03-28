class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	# -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------
# Account.destroy_all
# User.destroy_all
dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
iteration = 0
@customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
@customers_ext.each do |ce|
  if ce.InactiveCust == 0
    code = ce.Code.strip
    email = ce.EmailAddr
    if !Account.all.find_by(code: code)
      newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
      if newuser.save(:validate => false) #false to skip validation
        newuser.add_role :user
        newaccount = Account.new(code: code, user: newuser) #create the account and associate with user
        newaccount.save
      end
    end
  end
end
@customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
@customers.each do |c|
  if Account.all.find_by(code: c.Code.strip)
    account = Account.all.find_by(code: c.Code.strip)
    compname = c.Name
    street = c.Street
    suburb = c.Suburb 
    postcode = c.Postcode 
    phone = c.Phone 
    sort = c.Sort 
    discount = c.SpecialPriceCat 
    seller_level = c.PriceCat
    rep = c.SalesRep
    account.update_attributes(phone: phone, suburb: suburb, postcode: postcode, sort: sort, company: compname, rep: rep, seller_level: seller_level, discount: discount)
    @result << account.user.email
  end
end
dbh.disconnect
  end
end

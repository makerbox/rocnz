class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
    User.destroy_all
    Account.destroy_all
counter = 0
dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
@customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
@customers_ext.each do |ce|
  counter += 1
  if ce.InactiveCust == 0
    code = ce.Code.strip
    email = ce.EmailAddr
    if !Account.all.find_by(code: code)
      if email.blank?
        email = counter
      end
      if !User.all.find_by(email: email)
        newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
        if newuser.save(validate: false) #false to skip validation
          newuser.add_role :user
          newaccount = Account.new(code: code, user: newuser) #create the account and associate with user
          newaccount.save
        end
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
    account.update_attributes(approved: 'approved', phone: phone, suburb: suburb, postcode: postcode, sort: sort, company: compname, rep: rep, seller_level: seller_level, discount: discount)
  end
end
# @contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
# @contacts.each do |contact|
#   if contact.Active == 1
#     email = contact.EmailAddress
#     code = contact.Code
#     newcontact = Contact.new(email: email, code: code)
#     if thisaccount = Account.all.find_by(code: code)
#       thisaccount.user.update_attributes(email: email)
#       newcontact.save
#     end
#   end
# end
# dbh.disconnect

# #-------------------------- CREATE ADMIN USER -------------------------------------
# adminuser = User.all.find_by(email: 'web@roccloudy.com')
# adminuser.add_role :admin
# adminuser.account.update_attributes(approved: 'approved')

# #-------------------------- CREATE REP ACCOUNTS -----------------------------------
# dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
# @reps = dbh.execute("SELECT * FROM sales_reps_extn").fetch(:all, :Struct)
# @reps.each do |rep|
#   if rep.Inactive == 'N'
#     code = rep.Code
#     if email = rep.EmailAddress
#       repuser = User.new(email: email, password: 'cloudy_rep_123', password_confirmation: 'cloudy_rep_123')
#       if repuser.save(validate: false)
#         repaccount = Account.new(code: code, user: repuser)
#         repaccount.save
#         repuser.add_role :admin
#       end
#     end
#   end
# end
# dbh.disconnect
  end
end

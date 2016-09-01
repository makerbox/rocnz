# ensure there is an admin account
adminuser = User.find_by(email: "web@roccloudy.com")
if !adminuser
User.create(email: "web@roccloudy.com", password: "cloudy_16", password_confirmation: "cloudy_16")
else
	if !adminuser.has_role? :admin
		adminuser.add_role :admin
	end
end

# ----------------------------------

# get data out of attache and into sql
require 'rdbi-driver-odbc'

dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
	

products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
products.each do |p|
	if p.Inactive == 0
		if Product.find_by(code: p.Code)
	Product.find_by(code: p.Code).update(code: p.Code, description: p.Description, group: p.ProductGroup, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
		else
	Product.create(code: p.Code, description: p.Description, group: p.ProductGroup, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
#upload image to cloudinary and store url in product.imageurl (images are stored in z:/attache/roc/images/product/*sku*.jpg)
end
end
end

activecustomers = dbh.execute("SELECT * FROM customer_mastext WHERE InactiveCust=0").fetch(:all, :Struct)
activecustomers.each do |activecustomer|
	if !Account.find_by(code: activecustomer.Code)
		newuser =  User.create(email: "newuser@roccloudy.com", password: "roccloudyportal", password_confirmation: "roccloudyportal")
		Account.create(code: activecustomer.Code, user: newuser)
	end
end

customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
customers.each do |cust|
	@account = Account.find_by(code: cust.Code)
	if @account
		if @account.user #if the account doesn't belong to a user, we need to create one for them combining their company code (without spaces) and @roccloudy.com
			user_email = cust.Code
			user_email = user_email.to_s.strip + "@roccloudy.com"
			@account.user.update(email: user_email, password: "roccloudyportal", password_confirmation: "roccloudyportal")
		end
		@account.update(approved: 'approved', name: cust.Name, street: cust.Street, suburb: cust.Suburb, postcode: cust.Postcode, phone: cust.Phone, contact: cust.Contact, seller_level: cust.PriceCat)
	end
end

print "products: "
puts Product.count
print "accounts: "
puts Account.count
print "users: "
puts User.count
print "admin user: "
User.each do |test|
	if test.has_role? :admin
		puts test.email
	end
end
#customer_transactions file
#how to get which brands a customer can see?

# CUSTOMER ORDER AS SEPARATE SCAFFOLD - EACH ORDER TRANSLATED INTO KFI FILE? CAN WE INTERACT WITH THE DATABASE DIRECTLY WITHOUT KFI?

# get the fields that you need - check brief
# populate database from the required fields
# populate existing users
# make chronjob for seed
# build front end - check pricing is correct
# check sign up process works and is smooth
# build ordering process - ensure it is smooth
# build account management system for users to check invoices etc

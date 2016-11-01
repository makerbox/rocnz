



# #REALLY NEED TO MAKE THIS NEATER AND MORE EFFICIENT - BUILD METHODS AND DRY UP CODE


# @notice = []; # creating variable to store array of notices that will display after running



# # ensure there is an admin account
# adminuser = User.find_by(email: "web@roccloudy.com")
# if !adminuser
# admin = User.create(email: "web@roccloudy.com", password: "cloudy_16", password_confirmation: "cloudy_16")
# adminaccount = Account.create(user: admin)
# adminaccount.update(sort:'U L P R')
# else
# 	if !adminuser.has_role? :admin
# 		adminuser.add_role :admin
# 		adminaccount = adminuser.account
# 		adminaccount.update(sort:'U L P R')
# 	end
# end

# # ----------------------------------

# # get data out of attache and into sql
# require 'rdbi-driver-odbc'

dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

discounts.each do |d|
	percent = d.DiscPerc1 + d.DiscPerc2 + d.DiscPerc3 + d.DiscPerc4
	if percent > 0 # check there is an actual discount to apply
		if d.CustomerType == 10 # affect discounts for customer codes
			if d.ProductType == 10 # affect discounts for product codes
				if Discount.find_by(customertype: 'code', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
					puts 'exists'
				else
					Discount.create(customertype: 'code', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
				end
			elsif d.ProductType == 30 # affect discounts for product groups
				if Discount.find_by(customertype: 'code', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
					puts 'exists'
				else
					Discount.create(customertype: 'code', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
				end
			end
		elsif d.CustomerType == 30 # affect discounts for customer groups
			if d.ProductType == 10 # affect discounts for product codes
				if Discount.find_by(customertype: 'group', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
					puts 'exists'
				else
					Discount.create(customertype: 'group', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
				end
			elsif d.ProductType == 30 # affect discounts for product groups
				if Discount.find_by(customertype: 'group', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
					puts 'exists'
				else
					Discount.create(customertype: 'group', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
				end
			end
		end
	end
end




Product.each do |prod|
	trans = Transaction.where(prodcode: prod.code, custcode: 'ROC CLOU').first
	prod.update(new_date: trans.date)
end













# contacts.each do |contact| # populate a model of contact email addresses - had to be done to make the data searchable
# 	if Contact.find_by(code: contact.Code)
# 		puts "contact exists skipping"
# 	else
# 		Contact.create(code: contact.Code, email: contact.EmailAddress)
# 	end
# end

# inactive = 0 #use this to count inactive customers
# counter = 0 #use this counter to generate an email address for some users in the loop below
# #create accounts and users for active customers only if they don't exist already
# activecustomers.each do |activecustomer|
# 	@contact = Contact.find_by(code: activecustomer.Code)
# 	if @contact # if there is a contact email address for this customer code, then use it
# 		if @contact.email
# 			email = @contact.email
# 		else
# 			counter = counter + 1
# 			email = counter.to_s + "@wholesaleportal.com"
# 		end
# 	else #otherwise use the counter to generate an email address
# 		counter = counter + 1
# 		email = counter.to_s + "@wholesaleportal.com"
# 	end
# 	if Account.find_by(code: activecustomer.Code) #if there is already an account, skip it
# 		puts "account exists - skipping to next one"
# 	elsif activecustomer.InactiveCust == 0 #otherwise check if it is active
# 		newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
# 		if newuser.save
# 			newuser.add_role :user
# 			newaccount = Account.new(code: activecustomer.Code, user: newuser) #create the account and associate with user
# 			newaccount.save
# 		else
# 			puts newuser.email #if user wasn't created - show me the culprit
# 			if User.find_by(email: newuser.email) #if is was a duplicate, let's do it again, but with the counter for the email address
# 				puts "--DUPLICATE--USING COUNTER"
# 				counter = counter + 1
# 				email = counter.to_s + newuser.email
# 				newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal")
# 				newuser.save
# 				newuser.add_role :user
# 				newaccount = Account.new(code: activecustomer.Code, user: newuser)
# 				newaccount.save		
# 			end
# 		end

# 	else #if the account doesn't exist, but it's inactive, then skip creation
# 		inactive = inactive + 1
# 	end
# end
#update accounts with full details
customers.each do |customer| #use the data from customers to fill in the blanks in Accounts
	account = Account.find_by(code: customer.Code)
	discount = ''
	if account
		if customer.SpecialPriceCat
			discount = customer.SpecialPriceCat.strip
			puts discount
		else
			discount = nil
		end
		account.update(approved: 'approved', company: customer.Name, street: customer.Street, suburb: customer.Suburb, postcode: customer.Postcode, phone: customer.Phone, contact: customer.Contact, seller_level: customer.PriceCat, sort: customer.Sort, discount: discount)
	end
end

# #output a little bit of result data to the console - for debugging only
# puts "."
# print "products: "
# puts Product.count
# print "user keys: "
# puts User.count
# print "admin user: "
# User.all.each do |t|
# 	if t.has_role? :admin
# 		puts t.email
# 	end
# end
# print "accounts: "
# puts Account.count
# print "approved accounts:"
# puts Account.where(approved: "approved").count
# print "unapproved accounts:"
# puts Account.where(approved: nil).count
# print "inactive customers:"
# puts inactive

dbh.disconnect

ActiveRecord::Base.connection.execute("BEGIN TRANSACTION; END;")





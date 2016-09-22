



#REALLY NEED TO MAKE THIS NEATER AND MORE EFFICIENT - BUILD METHODS AND DRY UP CODE


@notice = []; # creating variable to store array of notices that will display after running



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

puts "connecting to database"
dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
# dbh = RDBI.connect :ODBC, :db => "testroc2"	

puts "updating products"
products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
produdefdata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)

productcounter = 0
products.each do |p|
	productcounter = productcounter + 1
	print productcounter / (products.length.to_f / 100) 
	print "%\r"
	if p.Inactive == 0
		@product = Product.find_by(code: p.Code)
		category = ''
		productsext.each do |x| #match the extension file with this product
			if x.Code == p.Code
				category = x.CostCentre
			end
		end

		if @product #if the product already exists, just update the details
			if @product.category != category || @product.code != p.Code || @product.description != p.Description || @product.group != p.ProductGroup || @product.price1 != p.SalesPrice1 || @product.price2 != p.SalesPrice2 || @product.price3 != p.SalesPrice3 || @product.price4 != p.SalesPrice4 || @product.price5 != p.SalesPrice5 || @product.rrp != p.SalesPrice6 || @product.qty != p.QtyInStock 
				@thisproduct = Product.find_by(code: p.Code)
				@pending_sold = 0 #set pending sold qty to zero
				Order.where(approved: false).each do |order| #for each pending order
					@pending_sold = @pending_sold + order.quantities.where(product_id: @thisproduct.id).sum(:qty) #find how many of this product are on it
				end
				current_quantity = p.QtyInStock - @pending_sold #qty is qty available minus pending orders
				#now for the date of arrival
				produdefdata.each do |pro| #for each of the rows in the product user defined data file
					if pro.Code == p.Code #see if it is the right product
						onsale = pro.DateFld #if it is the right record, then take it's date and put it in the onsale variable
					else
						onsale = nil #otherwise just make it nil (produdefdata only contains records that are filled in)
					end
				end
				@thisproduct.update(new_date: onsale, category: category, qty: current_quantity, code: p.Code, description: p.Description, group: p.ProductGroup, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
			else
				puts "already in db, skipping product"
			end
		else #if the product doesn't already exist, let's make it
			#check if there is an image for the product (images are stored in z:/attache/roc/images/product/*sku*.jpg)
			filename = "Z:\\Attache\\Roc\\Images\\Product\\" + p.Code.strip + '.jpg'
			if File.exist?(filename) # if there is an image, then create the product
				Cloudinary::Uploader.upload(filename, :public_id => p.Code.strip, :overwrite => true)
				#now for the date of arrival
				produdefdata.each do |pro| #for each of the rows in the product user defined data file
					if pro.Code == p.Code #see if it is the right product
						onsale = pro.DateFld #if it is the right record, then take it's date and put it in the onsale variable
					else
						onsale = nil #otherwise just make it nil (produdefdata only contains records that are filled in)
					end
				end
				Product.create(new_date: onsale, category: category, qty: p.QtyInStock, code: p.Code, description: p.Description, group: p.ProductGroup, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
			else
				puts "no image, skipping product"
			end
		end
	end
end

puts "updating accounts and users"
customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)

contacts.each do |contact| # populate a model of contact email addresses - had to be done to make the data searchable
	if Contact.find_by(code: contact.Code)
		puts "contact exists skipping"
	else
		Contact.create(code: contact.Code, email: contact.EmailAddress)
	end
end

inactive = 0 #use this to count inactive customers
counter = 0 #use this counter to generate an email address for some users in the loop below
#create accounts and users for active customers only if they don't exist already
activecustomers.each do |activecustomer|
	@contact = Contact.find_by(code: activecustomer.Code)
	if @contact # if there is a contact email address for this customer code, then use it
		if @contact.email
			email = @contact.email
		else
			counter = counter + 1
			email = counter.to_s + "@wholesaleportal.com"
		end
	else #otherwise use the counter to generate an email address
		counter = counter + 1
		email = counter.to_s + "@wholesaleportal.com"
	end
	if Account.find_by(code: activecustomer.Code) #if there is already an account, skip it
		puts "account exists - skipping to next one"
	elsif activecustomer.InactiveCust == 0 #otherwise check if it is active
		newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
		if newuser.save
			newuser.add_role :user
			newaccount = Account.new(code: activecustomer.Code, user: newuser) #create the account and associate with user
			newaccount.save
		else
			puts newuser.email #if user wasn't created - show me the culprit
			if User.find_by(email: newuser.email) #if is was a duplicate, let's do it again, but with the counter for the email address
				puts "--DUPLICATE--USING COUNTER"
				counter = counter + 1
				email = counter.to_s + newuser.email
				newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal")
				newuser.save
				newuser.add_role :user
				newaccount = Account.new(code: activecustomer.Code, user: newuser)
				newaccount.save		
			end
		end

	else #if the account doesn't exist, but it's inactive, then skip creation
		inactive = inactive + 1
	end
end
#update accounts with full details
customers.each do |customer| #use the data from customers to fill in the blanks in Accounts
	account = Account.find_by(code: customer.Code)
	if account
		account.update(approved: 'approved', company: customer.Name, street: customer.Street, suburb: customer.Suburb, postcode: customer.Postcode, phone: customer.Phone, contact: customer.Contact, seller_level: customer.PriceCat, sort: customer.Sort)
	end
	print "."
end

#output a little bit of result data to the console - for debugging only
puts "."
print "products: "
puts Product.count
print "user keys: "
puts User.count
print "admin user: "
User.all.each do |t|
	if t.has_role? :admin
		puts t.email
	end
end
print "accounts: "
puts Account.count
print "approved accounts:"
puts Account.where(approved: "approved").count
print "unapproved accounts:"
puts Account.where(approved: nil).count
print "inactive customers:"
puts inactive

dbh.disconnect

ActiveRecord::Base.connection.execute("BEGIN TRANSACTION; END;")
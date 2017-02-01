class PopulateJob
	include SuckerPunch::Job
 def perform
#THIS WILL COMPLETELY SEED THE DATABASE - ONLY RUN AT NIGHT
Contact.create(code:'running', email:'running')
@time = Time.now

    @results = []
    
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"


# -------------------------GET PRODUCTS AND CREATE / UPDATE PRODUCT RECORDS------------------------
    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)

    @products.each do |p|
      if p.Inactive == 0
        code = p.Code.strip
        description = p.Description.to_s.strip
        price1 = p.SalesPrice1
        price2 = p.SalesPrice2
        price3 = p.SalesPrice3
        price4 = p.SalesPrice4
        price5 = p.SalesPrice5
        rrp = p.SalesPrice6
        qty = p.QtyInStock
        group = p.ProductGroup.to_s.strip
        # # needs category
        if !Product.all.where(code: code).blank?
          Product.all.find_by(code: code).update_attributes(group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
          if File.exist?(filename)
            Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          else
            Product.all.find_by(code: code).destroy
          end
        else
          newproduct = Product.new(group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
          if File.exist?(filename)
            Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          end
          newproduct.save
        end
      end
    end

# ------------------------GET DATES AND UPDATE THE PRODUCTS WITH new_date FIELD-----------------------
    @datedata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)

    @datedata.each do |d|
      code = d.Code.strip
      if Product.find_by(code: code)
        Product.find_by(code: code).update_attributes(new_date: d.DateFld)
      end
    end

# ------------------------META DATA--------------------------------------------------------------
    @results << Product.count
    @time = (Time.now - @time) / 60
    dbh.disconnect
    
# ------------------------DISCOUNTS---------------------------------------------------------
Discount.destroy_all #wipe existing discounts in case of some deletions in Attache

    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

    discounts.each do |d|


      if d.PriceCode1 == 9 #if the discount is a fixed price
        discount = d.Price1 + d.Price2 + d.Price3 + d.Price4
        if d.CustomerType == 10
          customertype = 'code_fixed'
        else
          customertype = 'group_fixed'
        end
        if d.ProductType == 10
          producttype = 'code_fixed'
        else
          producttype = 'group_fixed'
        end
      else
        discount = d.DiscPerc1 + d.DiscPerc2 + d.DiscPerc3 + d.DiscPerc4
        if d.CustomerType == 10
          customertype = 'code_percent'
        else
          customertype = 'group_percent'
        end
        if d.ProductType == 10
          producttype = 'code_percent'
        else
          producttype = 'group_percent'
        end
      end

      if !d.Customer.blank? && !d.Product.blank?
        Discount.create(customertype: customertype, producttype: producttype, customer: d.Customer.strip, product: d.Product.strip, discount: discount)
      end

    end

    dbh.disconnect   























    # customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
    # activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
    # contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
    # discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    # products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    # productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    # reps = dbh.execute("SELECT * FROM sales_reps_extn").fetch(:all, :Struct)

    # reps.each do |r|
      # create or update rep account
      # create requires them to become admin
    # end

    # products.each do |p|
    #   if p.Inactive == 0
        # alldates = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)
        # if alldates.where(Code: p.Code)
        #   saledate = alldates.where(Code: p.Code)
        # else
        #   saledate = Date.today - 40.days
        # end

        # product = Product.where(code: p.Code.to_s.strip).first

        # category = dbh.execute("SELECT CostCentre FROM prodmastext WHERE Code = '#{p.Code}' ").fetch(:all, :Struct)[0].to_h[:CostCentre]
        # if category != nil
        #   category = category.strip
        # end
        
        # if product #if the product already exists, just update the details and destroy any without images
        #   if (product.new_date != saledate) || (product.category != category.to_s.strip) || (product.code != p.Code.to_s.strip) || (product.description != p.Description) || (product.group != p.ProductGroup.to_s.strip) || (product.price1 != p.SalesPrice1) || (product.price2 != p.SalesPrice2) || (product.price3 != p.SalesPrice3) || (product.price4 != p.SalesPrice4) || (product.price5 != p.SalesPrice5) || (product.rrp != p.SalesPrice6) || (product.qty != p.QtyInStock) 
        #     filename = "Z:\\Attache\\Roc\\Images\\Product\\" + p.Code.to_s.strip + '.jpg'
        #     if File.exist?(filename)
        #       Cloudinary::Uploader.upload(filename, :public_id => p.Code.to_s.strip, :overwrite => true)
        #     else
        #       # destroy the product - no image, no dice
        #       Product.find_by(code: p.Code.to_s.strip).destroy
        #     end
        #     product.update(new_date: saledate, category: category.to_s.strip, qty: p.QtyInStock, code: p.Code.to_s.strip, description: p.Description, group: p.ProductGroup.to_s.strip, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
        #   end
        # else #if the product doesn't already exist, let's make it
        #   Product.create(new_date: saledate, category: category.to_s.strip, qty: p.QtyInStock, code: p.Code.to_s.strip, description: p.Description, group: p.ProductGroup.to_s.strip, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
        #   #upload image to cloudinary and store url in product.imageurl (images are stored in z:/attache/roc/images/product/*sku*.jpg)
        #   filename = "Z:\\Attache\\Roc\\Images\\Product\\" + p.Code.to_s.strip + '.jpg'
        #   if File.exist?(filename)
        #     Cloudinary::Uploader.upload(filename, :public_id => p.Code.to_s.strip, :overwrite => true)
        #   else
        #     # destroy the product - no image, no dice
        #     Product.find_by(code: p.Code.to_s.strip).destroy
        #   end
        # end
    #   end
    # end

    # discounts.each do |d|
    #   if d.PriceCode1 != 0 #if the discount is a fixed price
    #     percent = 0 #temporary while under construction
    #     #percent = d.Price1 and flag as fixed price somehow -- still under construction
    #   else
    #     percent = d.DiscPerc1 + d.DiscPerc2 + d.DiscPerc3 + d.DiscPerc4
    #   end
    #   if percent > 0 # check there is an actual discount to apply
    #     if d.CustomerType == 10 # affect discounts for customer codes
    #       if d.ProductType == 10 # affect discounts for product codes
    #         if Discount.where(customertype: 'code', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
    #           # do nothing
    #         else
    #           Discount.create(customertype: 'code', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
    #         end
    #       elsif d.ProductType == 30 # affect discounts for product groups
    #         if Discount.where(customertype: 'code', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
    #           # do nothing
    #         else
    #           Discount.create(customertype: 'code', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
    #         end
    #       end
    #     elsif d.CustomerType == 30 # affect discounts for customer groups
    #       if d.ProductType == 10 # affect discounts for product codes
    #         if Discount.where(customertype: 'group', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
    #           # do nothing
    #         else
    #           Discount.create(customertype: 'group', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
    #         end
    #       elsif d.ProductType == 30 # affect discounts for product groups
    #         if Discount.where(customertype: 'group', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
    #           # do nothing
    #         else
    #           Discount.create(customertype: 'group', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
    #         end
    #       end
    #     end
    #   end
    # end

#   	# GET THE DATA INTO VARIABLES--------------------------------------------------------------------------
#     dbh = RDBI.connect :ODBC, :db => "wholesaleportal" # connect to DB

# 	customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
# 	activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
# 	contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
# 	# ----------------------------------------------------------------------------------------------------------

# 	# POPULATE CONTACTS-----------------------------------------------------------------------------------------
# 	contacts.each do |contact| # populate a model of contact email addresses - had to be done to make the data searchable
# 		if Contact.find_by(code: contact.Code)
# 			puts "contact exists skipping"
# 		else
# 			Contact.create(code: contact.Code, email: contact.EmailAddress)
# 		end
# 	end
# 	# ----------------------------------------------------------------------------------------------------------
# 	# POPULATE ACCOUNTS-----------------------------------------------------------------------------------------
# 	inactive = 0 #use this to count inactive customers
# 	counter = 0 #use this counter to generate an email address for some users in the loop below
# 	activecustomers.each do |activecustomer|
# 		@contact = Contact.find_by(code: activecustomer.Code)
# 		if @contact # if there is a contact email address for this customer code, then use it
# 			if @contact.email
# 				email = @contact.email
# 			else
# 				counter = counter + 1
# 				email = counter.to_s + "@wholesaleportal.com"
# 			end
# 		else #otherwise use the counter to generate an email address
# 			counter = counter + 1
# 			email = counter.to_s + "@wholesaleportal.com"
# 		end
# 		if Account.find_by(code: activecustomer.Code) #if there is already an account, skip it
# 			puts "account exists - skipping to next one"
# 		elsif activecustomer.InactiveCust == 0 #otherwise check if it is active
# 			newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
# 			if newuser.save
# 				newuser.add_role :user
# 				newaccount = Account.new(code: activecustomer.Code, user: newuser) #create the account and associate with user
# 				newaccount.save
# 			else
# 				puts newuser.email #if user wasn't created - show me the culprit
# 				if User.find_by(email: newuser.email) #if is was a duplicate, let's do it again, but with the counter for the email address
# 					puts "--DUPLICATE--USING COUNTER"
# 					counter = counter + 1
# 					email = counter.to_s + newuser.email
# 					newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal")
# 					newuser.save
# 					newuser.add_role :user
# 					newaccount = Account.new(code: activecustomer.Code, user: newuser)
# 					newaccount.save		
# 				end
# 			end

# 		else #if the account doesn't exist, but it's inactive, then skip creation
# 			inactive = inactive + 1
# 		end
# 	end
# 	#update accounts with full details
# 	customers.each do |customer| #use the data from customers to fill in the blanks in Accounts
# 		account = Account.find_by(code: customer.Code)
# 		if account
# 			account.update(approved: 'approved', company: customer.Name, street: customer.Street, suburb: customer.Suburb, postcode: customer.Postcode, phone: customer.Phone, contact: customer.Contact, seller_level: customer.PriceCat, sort: customer.Sort)
# 		end
# 		print "."
# 	end
# 	# ----------------------------------------------------------------------------------------------------------


# dbh.disconnect

# ActiveRecord::Base.connection.execute("BEGIN TRANSACTION; END;")

  Contact.where(code:'running').each do |del|
    del.destroy
  end

end #end perform

end #end class
class PopulateJob
	include SuckerPunch::Job
 def perform
  Contact.destroy_all
  Contact.create(code:'clock', email:'start')
    if Contact.find_by(code:'running', email:'running')
      puts 'already running' #skips running again if already running
    else
      Contact.create(code:'running', email:'running')


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
              pricecat = p.PriceCat.to_s.strip
              # # needs category
              if !Product.all.where(code: code).blank?
                Product.all.find_by(code: code).update_attributes(pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
                filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
                if File.exist?(filename)
                  # Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                else
                  Product.all.find_by(code: code).destroy
                end
              else
                newproduct = Product.new(pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
                filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
                if File.exist?(filename)
                  Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
                  # stop from overloading transformations
                  newproduct.save
                end
                
              end
            end
          end

          dbh.disconnect

      #-------------------------UPDATE PRODUCTS WITH CATEGORIES -------------------------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
      @categories = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
      @categories.each do |cat|
            if cat.CostCentre #if the prodmastext record has a category, then let's do it
              categorycode = cat.Code.strip
              if Product.find_by(code: categorycode) #if the product exists, let's give it the category (some products without images have no dice)
                Product.find_by(code: categorycode).update_attributes(category: cat.CostCentre.strip)
              end
            end
          end
          dbh.disconnect

      # ------------------------GET DATES AND UPDATE THE PRODUCTS WITH new_date FIELD-----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      @datedata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)

      @datedata.each do |d|
        code = d.Code.strip
        if Product.find_by(code: code)
          Product.find_by(code: code).update_attributes(new_date: d.DateFld)
        end
      end

      dbh.disconnect

      # ------------------------GET FABS, CONNECT THEM, AND UPDATE THE PRODUCTS-----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

      @fabdata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)
      fab = ''
      @fabdata.each do |d|
        code = d.Code.strip
        if Product.find_by(code: code)
          if !d.TextFld.blank?
            fab = d.TextFld.strip
            Product.find_by(code: code).update_attributes(fab: fab)
          end
        end
      end

      dbh.disconnect

      # ------------------------DISCOUNTS---------------------------------------------------------
       Discount.destroy_all #wipe existing discounts in case of some deletions in Attache
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
          discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

          def disco(percentage, fixed, fixedprice, level, maxqty, ctype, ptype, cust, prod)
            if fixedprice == 9 #if the discount is a fixed price
              disctype = 'fixedtype'
              discount = fixed
              if ctype == 10
                customertype = 'code_fixed'
              else
                customertype = 'group_fixed'
              end
              if ptype == 10
                producttype = 'code_fixed'
              elsif ptype == 30
                producttype = 'group_fixed'
              else
                producttype = 'cat_fixed'
              end
            else
              disctype = 'percentagetype'
              discount = percentage
              if ctype == 10
                customertype = 'code_percent'
              else
                customertype = 'group_percent'
              end
              if ptype == 10
                producttype = 'code_percent'
              elsif ptype == 30
                producttype = 'group_percent'
              else
                producttype = 'cat_percent'
              end
            end
            if maxqty #sometimes there is no qty
              if maxqty >= 10000 #sometimes it's way too big to store as an integer
                maxqty = 9999
              end
            end
            if !prod.nil? && !cust.nil?
              Discount.create(customertype: customertype, producttype: producttype, customer: cust.strip, product: prod.strip, discount: discount, level: level, maxqty: maxqty, disctype: disctype)
            end

          end

          discounts.each do |d|
            if (d.LevelNum >= 1) 
              percentage = d.DiscPerc1
              fixed = d.Price1
              fixedprice = d.PriceCode1
              level = 1
              maxqty = d.MaxQty1
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum >= 2) 
              percentage = d.DiscPerc2
              fixed = d.Price2
              fixedprice = d.PriceCode2
              level = 2
              maxqty = d.MaxQty2
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum >= 3) 
              percentage = d.DiscPerc3
              fixed = d.Price3
              fixedprice = d.PriceCode3
              level = 3
              maxqty = d.MaxQty3
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum >= 4) 
              percentage = d.DiscPerc4
              fixed = d.Price4
              fixedprice = d.PriceCode4
              level = 4
              maxqty = d.MaxQty4
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum >= 5) 
              percentage = d.DiscPerc5
              fixed = d.Price5
              fixedprice = d.PriceCode5
              level = 5
              maxqty = d.MaxQty5
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum >= 6) 
              percentage = d.DiscPerc6
              fixed = d.Price6
              fixedprice = d.PriceCode6
              level = 6
              maxqty = d.MaxQty6
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
          end

          dbh.disconnect 

      # -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------

      counter = 0
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @customers_ext = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
      @customers_ext.each do |ce|
        counter += 1
        code = ce.Code.strip
        if ce.InactiveCust == 1
          if Account.all.find_by(code: code)
            account = Account.all.find_by(code: code) # if there is an attache inactive account already in the portal, we delete it and its user
            user = account.user
            account.destroy
            user.destroy
          end
        else
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
        code = c.Code.strip
        if Account.all.find_by(code: code)
          account = Account.all.find_by(code: code)
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
      dbh.disconnect 

      # --------------------- ADD EMAIL ADDRESSES ----------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
      contacts.each do |contact|
        if contact.Active == 1
          if account = Account.all.find_by(code: contact.Code.strip)
            # if !User.all.find_by(email: contact.EmailAddress)
            #   account.user.update_attribute(email: contact.EmailAddress)
            # end
          end
        end
      end
      dbh.disconnect 





      # @contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
      # @contacts.each do |contact|
      #   if (contact.Active == 1) && (!Contact.all.find_by(code: contact.Code.strip))
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

      #-------------------------- MAKE ALL USERS CUSTOMER ROLE -------------------------
      User.all.add_role :customer
      
      #-------------------------- CREATE ADMIN USER -------------------------------------
      if adminuser = User.all.find_by(email: 'web@roccloudy.com')
        adminuser.add_role :admin
        if adminuser.account
          adminuser.account.update_attributes(approved: 'approved', sort: 'U/L/R/P')
        else
          Account.create(code: 'ADMIN', company: 'Roc', user: adminuser, sort: 'U/L/R/P')
        end
      else
        adminuser = User.new(email: 'web@roccloudy.com', password:'cloudy_16', password_confirmation: 'cloudy_16')
        adminuser.add_role :admin
        adminuser.save(validate: false)
        Account.create(code: 'ADMIN', company: 'Roc', user: adminuser, sort: 'U/L/R/P')
      end

      #-------------------------- CREATE REP ACCOUNTS -----------------------------------
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
      @reps = dbh.execute("SELECT * FROM sales_reps_extn").fetch(:all, :Struct)
      @reps.each do |rep|
        if rep.Inactive == 'N'
          code = rep.Code
          if email = rep.EmailAddress
            repuser = User.new(email: email, password: 'cloudy_rep_123', password_confirmation: 'cloudy_rep_123')
            if repuser.save(validate: false)
              repaccount = Account.new(code: code, user: repuser)
              repaccount.save
              repuser.add_role :admin
            end
          end
        end
      end
      dbh.disconnect

      # ------------------------META DATA--------------------------------------------------------------

      Contact.where(code:'running').each do |del|
        del.destroy
      end
      Contact.create(code:'clock', email:'end')
    end #end if running check
end #end perform

end #end class
class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		# @goodcount = 0
		# @badcount = 0
		# @results = []
		# @users = User.all
		# @users.each do |u|
		# 	if u.email.include? '@'
		# 		@goodcount = @goodcount + 1
		# 	else
		# 		@badcount = @badcount + 1
		# 		@results << u.account
		# 	end
		# end
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
                newproduct = Product.new(pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty, hidden: false)
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
      

		# OrderMailer.receipt(Order.all.last, current_user).deliver_now
		# @result = `heroku db:push [postgres://bpupvrcqomwfwk:55tz1h8GUNGOyWVTkWFjAttzY7@ec2-54-225-244-221.compute-1.amazonaws.com:5432/de53vgd0mccdbt]`
	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
  end
end
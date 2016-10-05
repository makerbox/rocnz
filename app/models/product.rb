class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def self.populate
	require 'rdbi-driver-odbc'
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
	productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
	produdefdata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)
	prodtrans = dbh.execute("SELECT * FROM PRODUCT_TRANSACTIONS").fetch(:all, :Struct)
	genledger = dbh.execute("SELECT * FROM genledger_sets").fetch(:all, :Struct)    
	products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
	dbh.disconnect

	products.each do |p|

	if p.Inactive == 0 #if product isn't inactive
		@product = Product.find_by(code: p.Code)
		category = ''
		productsext.each do |x| #match the extension file with this product
			if x.Code == p.Code
				category = x.CostCentre.strip
			end
		end
				#now for the date of arrival
				onsale = Date.today - 40.days #set onsale just in case there isn't one, because the program will skip the next loop entirely if it doesn't exist
				produdefdata.each do |pro| #for each of the rows in the product user defined data file
					if pro.Code == p.Code #see if it is the right product
						onsale = pro.DateFld #if it is the right record, then take it's date and put it in the onsale variable
					end
				end

		if @product #if the product already exists, just update the details
			if @product.new_date != onsale || @product.category != category || @product.code != p.Code || @product.description != p.Description || @product.group != p.ProductGroup.strip || @product.price1 != p.SalesPrice1 || @product.price2 != p.SalesPrice2 || @product.price3 != p.SalesPrice3 || @product.price4 != p.SalesPrice4 || @product.price5 != p.SalesPrice5 || @product.rrp != p.SalesPrice6 || @product.qty != p.QtyInStock 
				@thisproduct = Product.find_by(code: p.Code)
				@pending_sold = 0 #set pending sold qty to zero
				Order.where(approved: false).each do |order| #for each pending order
					@pending_sold = @pending_sold + order.quantities.where(product_id: @thisproduct.id).sum(:qty) #find how many of this product are on it
				end
				current_quantity = p.QtyInStock - @pending_sold #qty is qty available minus pending orders

				@thisproduct.update(new_date: onsale, category: category, qty: current_quantity, code: p.Code, description: p.Description, group: p.ProductGroup.strip, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
			else
				puts "already in db, skipping product"
			end
		else #if the product doesn't already exist, let's make it
			#check if there is an image for the product (images are stored in z:/attache/roc/images/product/*sku*.jpg)
			filename = "Z:\\Attache\\Roc\\Images\\Product\\" + p.Code.strip + '.jpg'
			if File.exist?(filename) # if there is an image, then create the product
				Cloudinary::Uploader.upload(filename, :public_id => p.Code.strip, :overwrite => true)
				#now for the date of arrival
				onsale = '' #set onsale just in case there isn't one, because the program will skip the next loop entirely if it doesn't exist
				produdefdata.each do |pro| #for each of the rows in the product user defined data file
					if pro.Code == p.Code #see if it is the right product
						onsale = pro.DateFld #if it is the right record, then take it's date and put it in the onsale variable
					end
				end
				Product.create(new_date: onsale, category: category, qty: p.QtyInStock, code: p.Code, description: p.Description, group: p.ProductGroup.strip, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
			else
				puts "no image, skipping product"
			end
		end
	end
end

end #end of class

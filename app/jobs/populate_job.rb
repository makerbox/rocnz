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
        pricecat = p.PriceCat
        # # needs category
        if !Product.all.where(code: code).blank?
          Product.all.find_by(code: code).update_attributes(pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
          if File.exist?(filename)
            Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          else
            Product.all.find_by(code: code).destroy
          end
        else
          newproduct = Product.new(pricecat: pricecat, group: group, code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "E:\\Attache\\Attache\\Roc\\Images\\Product\\" + code + ".jpg"
          if File.exist?(filename)
            Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          end
          newproduct.save
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

# ------------------------META DATA--------------------------------------------------------------
    @results << Product.count
    @time = (Time.now - @time) / 60
    Contact.where(code:'running').each do |del|
        del.destroy
    end

end #end perform

end #end class
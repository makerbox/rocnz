class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

def roc
end
def locello
end
def polasports
end
def unity
end
def confirm
end

  def pull
      system "git pull"
      # system "rake db:migrate"
      # system "rails restart -b 0.0.0.0"
      # system "rake jobs:work"
      # system "rake db:seed"
  end

  def test #this has a view, so you can check variables and stuff
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

    # customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
    # activecustomers = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
    # contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
    discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)
    products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    productsext = dbh.execute("SELECT * FROM prodmastext").fetch(:all, :Struct)
    reps = dbh.execute("SELECT * FROM sales_reps_extn").fetch(:all, :Struct)

    # reps.each do |r|
      # create or update rep account
      # create requires them to become admin
    # end

    products.each do |p|
        if p.Inactive == 0
# @saledate = nil
dbhstring = "SELECT * FROM produdefdata WHERE Code='#{p.Code}' " #p.Code.strip
@saledate = dbh.execute(dbhstring).fetch(:all, :Struct)
# @saledate = Date.today
if @saledate
    @saledate = @saledate.DateFld
else
    @saledate = nil
end
@product = Product.find_by(code: p.Code)
category = ''
productsext.each do |x| #match the extension file with this product
    if x.Code == p.Code
        category = x.CostCentre
    end
end

if @product #if the product already exists, just update the details
    if (@product.new_date != @sale_date) || (@product.category != category.to_s.strip) || (@product.code != p.Code.to_s.strip) || (@product.description != p.Description) || (@product.group != p.ProductGroup.to_s.strip) || (@product.price1 != p.SalesPrice1) || (@product.price2 != p.SalesPrice2) || (@product.price3 != p.SalesPrice3) || (@product.price4 != p.SalesPrice4) || (@product.price5 != p.SalesPrice5) || (@product.rrp != p.SalesPrice6) || (@product.qty != p.QtyInStock) 
        @product.update(new_date: @saledate, category: category.to_s.strip, qty: p.QtyInStock, code: p.Code.to_s.strip, description: p.Description, group: p.ProductGroup.to_s.strip, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
    end
else #if the product doesn't already exist, let's make it
# Product.create(new_date: @saledate, category: category.to_s.strip, qty: p.QtyInStock, code: p.Code.to_s.strip, description: p.Description, group: p.ProductGroup.to_s.strip, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
#upload image to cloudinary and store url in product.imageurl (images are stored in z:/attache/roc/images/product/*sku*.jpg)
filename = "Z:\\Attache\\Roc\\Images\\Product\\" + p.Code.to_s.strip + '.jpg'
if File.exist?(filename)
    Cloudinary::Uploader.upload(filename, :public_id => p.Code.to_s.strip, :overwrite => true)
end
end
end
    # Discount.all.each do |d|
    #   newcustomer = d.customer.strip
    #   newproduct = d.product.strip
    #   d.update(product: newproduct, customer: newcustomer)
    # end
    # @product = Product.all
    # product = '335B'
#     @print = "<h1>Testing by Matt</h1><table><thead><tr><th>product code</th><th>price</th></tr></thead><tbody><tr><td>asdf</td><td>$123</td></tr></tbody></table><b>bold</b>"

#     `printhtml.exe html="#{@print}"`
# dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
#     # @transactions = dbh.execute("SELECT * FROM product_transactions WHERE Code='#{product}' AND CustomerSupplier='SAMPLES' ").fetch(:all, :Struct)
#    dbhstring = "SELECT * FROM produdefdata"
#    @saledate = dbh.execute(dbhstring).fetch(:all, :Struct)
   # establish_connection(wholesale)

  end

  def seed
    PopulateJob.perform_async()
    
    # contacts.each do |contact| # populate a model of contact email addresses - had to be done to make the data searchable
    #   if Contact.find_by(code: contact.Code)
    #     puts "contact exists skipping"
    #   else
    #     Contact.create(code: contact.Code, email: contact.EmailAddress)
    #   end
    # end

    # inactive = 0 #use this to count inactive customers
    # counter = 0 #use this counter to generate an email address for some users in the loop below
    # #create accounts and users for active customers only if they don't exist already
    # activecustomers.each do |activecustomer|
    #   @contact = Contact.find_by(code: activecustomer.Code)
    #   if @contact # if there is a contact email address for this customer code, then use it
    #     if @contact.email
    #       email = @contact.email
    #     else
    #       counter = counter + 1
    #       email = counter.to_s + "@wholesaleportal.com"
    #     end
    #   else #otherwise use the counter to generate an email address
    #     counter = counter + 1
    #     email = counter.to_s + "@wholesaleportal.com"
    #   end
    #   if Account.find_by(code: activecustomer.Code) #if there is already an account, skip it
    #     puts "account exists - skipping to next one"
    #   elsif activecustomer.InactiveCust == 0 #otherwise check if it is active
    #     newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal") #create the user
    #     if newuser.save
    #       newuser.add_role :user
    #       newaccount = Account.new(code: activecustomer.Code, user: newuser) #create the account and associate with user
    #       newaccount.save
    #     else
    #       puts newuser.email #if user wasn't created - show me the culprit
    #       if User.find_by(email: newuser.email) #if is was a duplicate, let's do it again, but with the counter for the email address
    #         puts "--DUPLICATE--USING COUNTER"
    #         counter = counter + 1
    #         email = counter.to_s + newuser.email
    #         newuser = User.new(email: email, password: "roccloudyportal", password_confirmation: "roccloudyportal")
    #         newuser.save
    #         newuser.add_role :user
    #         newaccount = Account.new(code: activecustomer.Code, user: newuser)
    #         newaccount.save   
    #       end
    #     end

    #   else #if the account doesn't exist, but it's inactive, then skip creation
    #     inactive = inactive + 1
    #   end
    # end
    # #update accounts with full details
    # customers.each do |customer| #use the data from customers to fill in the blanks in Accounts
    #   account = Account.find_by(code: customer.Code)
    #   if account
    #     account.update(approved: 'approved', company: customer.Name, street: customer.Street, suburb: customer.Suburb, postcode: customer.Postcode, phone: customer.Phone, contact: customer.Contact, seller_level: customer.PriceCat, sort: customer.Sort)
    #   end
    #   print "."
    # end
  end

  

end #end of class

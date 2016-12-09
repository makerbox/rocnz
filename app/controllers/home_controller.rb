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

  def pull
      system "git pull"
      # system "rake db:migrate"
      # system "rails restart -b 0.0.0.0"
      # system "rake jobs:work"
      # system "rake db:seed"
  end

  def test #this has a view, so you can check variables and stuff
    # Discount.all.each do |d|
    #   newcustomer = d.customer.strip
    #   newproduct = d.product.strip
    #   d.update(product: newproduct, customer: newcustomer)
    # end
    product = '335B'
    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    # @transactions = dbh.execute("SELECT * FROM product_transactions").fetch(:all, :Struct)
    @transactions = dbh.execute("SELECT * FROM product_transactions WHERE Code=#{product} AND CustomerSupplier='SAMPLES' ").fetch(:all, :Struct)
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

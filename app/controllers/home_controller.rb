class HomeController < ApplicationController
	skip_before_action :authenticate_user!
  def index

  end

  def pull
      system "git pull"
      # system "bundle"
      system "rails restart -b 0.0.0.0"
      # system "rake jobs:work"
      # system "rake db:seed"
  end

  def seed
    #THIS WILL COMPLETELY SEED THE DATABASE AND UPDATE EXISTING RECORDS - ONLY RUN AT NIGHT
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

    redirect_to :back
  end

  def test #this has a view, so you can check variables and stuff
    # Discount.all.each do |d|
    #   newcustomer = d.customer.strip
    #   newproduct = d.product.strip
    #   d.update(product: newproduct, customer: newcustomer)
    # end
  end

end #end of class

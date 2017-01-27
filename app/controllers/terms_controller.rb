class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []
    Discount.destroy_all #wipe the database for a clean start

    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

    discounts.each do |d|
      
      @results << 'pricecode1'
      @results << d.PriceCode1
      results << 'pricecode2'
      @results << d.PriceCode2
      results << 'pricecode3'
      @results << d.PriceCode3
      results << 'pricecode4'
      @results << d.PriceCode4
        @results << 'price1--'
        @results << d.Price1
        @results << 'price2--'
        @results << d.Price2
        @results << 'price3--'
        @results << d.Price1
        @results << 'price4--'
        @results << d.Price2  
      if d.PriceCode1 != 0 #if the discount is a fixed price
      
        percent = 0 #temporary while under construction
        #percent = d.Price1 and flag as fixed price somehow -- still under construction
      else
        percent = d.DiscPerc1 + d.DiscPerc2 + d.DiscPerc3 + d.DiscPerc4
      end
      if percent > 0 # check there is an actual discount to apply
        if d.CustomerType == 10 # affect discounts for customer codes
          if d.ProductType == 10 # affect discounts for product codes
            if Discount.where(customertype: 'code', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
              # do nothing
            else
              Discount.create(customertype: 'code', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
            end
          elsif d.ProductType == 30 # affect discounts for product groups
            if Discount.where(customertype: 'code', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
              # do nothing
            else
              Discount.create(customertype: 'code', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
            end
          end
        elsif d.CustomerType == 30 # affect discounts for customer groups
          if d.ProductType == 10 # affect discounts for product codes
            if Discount.where(customertype: 'group', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
              # do nothing
            else
              Discount.create(customertype: 'group', producttype: 'code', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
            end
          elsif d.ProductType == 30 # affect discounts for product groups
            if Discount.where(customertype: 'group', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent) # does it exist already?
              # do nothing
            else
              Discount.create(customertype: 'group', producttype: 'group', customer: d.Customer.strip, product: d.Product.strip, discount: percent)
            end
          end
        end
      end
    end

    dbh.disconnect

    Discount.all.each do |disc|
      @results << disc
    end

  end #end def index

end #end class

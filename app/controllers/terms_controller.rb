class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @results = []

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

      @results << d.Customer
      @results << d.Product
      # Product.create(customertype: customertype, producttype: producttype, customer: d.Customer.strip, product: d.Product.strip, discount: discount)

    end

    dbh.disconnect

  end #end def index

end #end class

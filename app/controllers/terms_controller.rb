class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
	@results = []
      dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
    discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

    def disco(percentage, fixed, fixedprice, level, maxqty)
      if fixedprice == 9 #if the discount is a fixed price
        discount = fixed
        if d.CustomerType == 10
          customertype = 'code_fixed'
        else
          customertype = 'group_fixed'
        end
        if d.ProductType == 10
          producttype = 'code_fixed'
        elsif d.ProductType == 30
          producttype = 'group_fixed'
        else
          producttype = 'cat_fixed'
        end
      else
        discount = percentage
        if d.CustomerType == 10
          customertype = 'code_percent'
        else
          customertype = 'group_percent'
        end
        if d.ProductType == 10
          producttype = 'code_percent'
        elsif d.ProductType == 30
          producttype = 'group_percent'
        else
          producttype = 'cat_percent'
        end
      end
@results << [producttype]
    end
    discounts.each do |d|
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc1
        fixed = d.Price1
        fixedprice = d.PriceCode1
        level = 1
        maxqty = d.MaxQty1
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc2
        fixed = d.Price2
        fixedprice = d.PriceCode2
        level = 2
        maxqty = d.MaxQty2
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc3
        fixed = d.Price3
        fixedprice = d.PriceCode3
        level = 3
        maxqty = d.MaxQty3
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc4
        fixed = d.Price4
        fixedprice = d.PriceCode4
        level = 4
        maxqty = d.MaxQty4
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc5
        fixed = d.Price5
        fixedprice = d.PriceCode5
        level = 5
        maxqty = d.MaxQty5
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc6
        fixed = d.Price6
        fixedprice = d.PriceCode6
        level = 6
        maxqty = d.MaxQty6
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc7
        fixed = d.Price7
        fixedprice = d.PriceCode7
        level = 7
        maxqty = d.MaxQty7
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc8
        fixed = d.Price8
        fixedprice = d.PriceCode8
        level = 8
        maxqty = d.MaxQty8
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc9
        fixed = d.Price9
        fixedprice = d.PriceCode9
        level = 9
        maxqty = d.MaxQty9
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
      if (d.PriceCode1 == 9) || (d.DiscCode1 == 9) 
        percentage = d.DiscPerc10
        fixed = d.Price10
        fixedprice = d.PriceCode10
        level = 10
        maxqty = d.MaxQty10
      end
      if !d.Customer.blank? && !d.Product.blank?
        disco(percentage, fixed, fixedprice, level, maxqty)
      end
    end

    dbh.disconnect   
  end #end def index

end #end class

class TestController < ApplicationController
	skip_before_action :authenticate_user!
	
	def index
		@output = []
		          Discount.destroy_all #wipe existing discounts in case of some deletions in Attache
          dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
          discounts = dbh.execute("SELECT * FROM product_special_prices").fetch(:all, :Struct)

          def disco(percentage, fixed, fixedprice, level, maxqty, ctype, ptype, cust, prod)
          	@output << 'disco'
          	@output << maxqty
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
          	@output << d.MaxQty1
          	@output << d.Customer
            if (d.LevelNum <= 1) 
              percentage = d.DiscPerc1
              fixed = d.Price1
              fixedprice = d.PriceCode1
              level = 1
              maxqty = d.MaxQty1
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum <= 2) 
              percentage = d.DiscPerc2
              fixed = d.Price2
              fixedprice = d.PriceCode2
              level = 2
              maxqty = d.MaxQty2
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum <= 3) 
              percentage = d.DiscPerc3
              fixed = d.Price3
              fixedprice = d.PriceCode3
              level = 3
              maxqty = d.MaxQty3
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum <= 4) 
              percentage = d.DiscPerc4
              fixed = d.Price4
              fixedprice = d.PriceCode4
              level = 4
              maxqty = d.MaxQty4
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum <= 5) 
              percentage = d.DiscPerc5
              fixed = d.Price5
              fixedprice = d.PriceCode5
              level = 5
              maxqty = d.MaxQty5
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
            if (d.LevelNum <= 6) 
              percentage = d.DiscPerc6
              fixed = d.Price6
              fixedprice = d.PriceCode6
              level = 6
              maxqty = d.MaxQty6
              disco(percentage, fixed, fixedprice, level, maxqty, d.CustomerType, d.ProductType, d.Customer, d.Product)
            end
          end

          dbh.disconnect 

	  	# system "heroku pg:push development postgresql-round-86328 --app shrouded-waters-74068"
	end
end
class Product < ActiveRecord::Base
has_many :quantities,  dependent: :destroy 
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat, qty)

	if u.account.discount
		udisc = u.account.discount.strip
	else
		udisc = nil
	end

	
	if discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || u.account.discount.strip))
		if disco = discos.first
		    if disco.disctype == 'fixedtype'
		      result =  disco.discount
		    else
		      result = price - ((price / 100) * disco.discount)
		    end
		else
			result = price
		end
	else
		result = price
	end

	return result
end




end #end of class

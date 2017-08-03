class Product < ActiveRecord::Base
has_many :quantities,  dependent: :destroy 
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat, qty)

	if u.mimic
		thisaccount = u.mimic.account
	else
		thisaccount = u.account
	end

	
	if discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (thisaccount.code.strip || thisaccount.discount))
		if disco = discos.where('maxqty >= ?', qty).first
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

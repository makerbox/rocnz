class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat)
	if Discount.all.find_by(product: prod_group, customer: u.account.code.strip)
		disco = Discount.all.find_by(product: prod_group, customer: u.account.code.strip)
		if disco.disctype == 'fixedtype'
			result = price - disco.discount
		else
			result = price - ((price / 100) * disco.discount)
		end
	else
		result = price
	end
	return result
end

def show_discount(u, prod_group, prod_code, price_cat)
	prod_group + '..' + prod_code + '..' + price_cat + '..' + u.account.code.strip
end

end #end of class

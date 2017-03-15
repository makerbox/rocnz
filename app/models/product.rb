class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat)
	if Discount.where(product: (prod_group || prod_code || price_cat)).where(customer: u.account.code.strip)
		disco = Discount.where(product: (prod_group || prod_code || price_cat)).where(customer: u.account.code.strip).first
		if disco.disctype == 'fixedtype'
			price - disco.discount
		else
			price - (price * (disco.discount / 100))
		end
	else
		price
	end
end

def show_discount(u, prod_group, prod_code, price_cat)
	prod_group + '..' + prod_code + '..' + price_cat + '..' + u.account.code.strip
end

end #end of class

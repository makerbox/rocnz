class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(user, price, prod_group, prod_code, price_cat)
	if Discount.where(product: (prod_group || prod_code || price_cat)).exists?
		disco = Discount.where(product: (prod_group || prod_code || price_cat)).first
		if disco.disctype == 'fixedtype'
			puts disco.producttype
			price - disco.discount
		else
			price - (price * (disco.discount / 100))
		end
	else
		price
	end
end

def show_discount(user, price, prod_group, prod_code, price_cat)
	if Discount.where(product: (prod_group || prod_code || price_cat)).exists?
		disco = Discount.where(product: (prod_group || prod_code || price_cat)).first
		result = disco.producttype
	else
		result = 'no discount'
	end
	result
end

end #end of class

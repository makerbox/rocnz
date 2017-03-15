class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(user, price, prod_group, prod_code, price_cat)
	if Discount.where(product: (prod_group || prod_code || price_cat), customer: user.account.code.strip).exists?
		disco = Discount.where(product: (prod_group || prod_code || price_cat), customer: user.account.code.strip).first
		if disco.disctype == 'fixedtype'
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
		result = disco.producttype + ' ' + disco.product + '-$' + disco.discount.to_s
	else
		result = 'no discount'
	end
	result
end

end #end of class

class Product < ActiveRecord::Base
has_many :quantities,  dependent: :destroy 
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat, qty)
	
	if discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code || u.account.discount))
		# FOR SOME REASON CHANGING THE ORDER OF THE 'price_cat || prod_code || prod_group' WORKS? THIS COULD MEAN SOMETHING ELSE IS WRONG
		# discos = (Discount.all.where(product: price_cat , customer: u.account.code)) || (Discount.all.where(product: prod_code , customer: u.account.code)) || (Discount.all.where(product: prod_group , customer: u.account.code)) || (Discount.all.where(product: price_cat , customer: u.account.discount)) || (Discount.all.where(product: prod_code , customer: u.account.discount)) || (Discount.all.where(product: prod_group , customer: u.account.discount))

		if discos.where('maxqty >= ?', qty).first
			disco = discos.where('maxqty >= ?', qty).first
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
	if discos = Discount.all.where(product: prod_group, customer: u.account.code)
		result = 1
	end
	if discos = Discount.all.where(product: prod_code, customer: u.account.code)
		result = 2
	end
	if discos = Discount.all.where(product: price_cat, customer: u.account.code)
		result = 3
	end
	return result
end




end #end of class

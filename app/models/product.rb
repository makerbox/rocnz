class Product < ActiveRecord::Base
has_many :quantities,  dependent: :destroy 
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat, qty)

	if Discount.all.where(product: (prod_group || prod_code || price_cat), customer: ('JOHN LUK' || u.account.discount))
		discos = Discount.all.where(product: (prod_group || prod_code || price_cat), customer: (u.account.code || u.account.discount))
		# if discos.where('maxqty >= ?', qty).first
			disco = discos.where('maxqty >= ?', qty).first
		    if disco.disctype == 'fixedtype'
		      result =  disco.discount
		    else
		      result = price - ((price / 100) * disco.discount)
		    end
		# else
			# result = 1
		# end
	else
		result = 2
	end

	return result
end




end #end of class

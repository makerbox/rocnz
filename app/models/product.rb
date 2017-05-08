class Product < ActiveRecord::Base
has_many :quantities
has_many :orders, through: :quantities

def calc_discount(u, price, prod_group, prod_code, price_cat)

	if u.account.discount
		udisc = u.account.discount.strip
	else
		udisc = nil
	end
	if Discount.all.find_by(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || udisc))
		disco = Discount.all.find_by(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || u.account.discount.strip))
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


def calc_qty_disc(qty)
  if current_user.mimic
    u = current_user.mimic.user
  else
    u = current_user
  end
  prod_group = @product.group
  prod_code = @product.code
  price_cat = @product.pricecat

  if Discount.all.find_by(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || u.account.discount.strip))
    disco = Discount.all.find_by(product: (prod_group || prod_code || price_cat), customer: (u.account.code.strip || u.account.discount.strip))
    result = qty
  else
    result = qty
  end
  return result
end



end #end of class

namespace :runner do

	task :empty_users do
		User.destroy_all
		Account.destroy_all
		Contact.destroy_all
	end

	task :empty_orders do
		Order.destroy_all
		Quantity.destroy_all
	end

	task :empty_products do
		Product.destroy_all
	end

	task :empty_all do
		User.destroy_all
		Account.destroy_all
		Contact.destroy_all
		Order.destroy_all
		Quantity.destroy_all
		Product.destroy_all
	end

end

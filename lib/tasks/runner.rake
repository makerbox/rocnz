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

	task :waiting do
		1000.times do |t|
			10.times do |b|
				print t * rand * b
				sleep 0.2
			end
			sleep 1
		end
	end

	task :attachecheck do
		require 'rdbi-driver-odbc'
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
		products = dbh.execute("SELECT * FROM product_master WHERE Code='007'").fetch(:all, :Struct)
		puts products
	end
	task :attacheput do
		require 'rdbi-driver-odbc'
		dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
		edition = dbh.execute("UPDATE product_master SET Inactive='0' WHERE Code='007'")
		products = dbh.execute("SELECT * FROM product_master WHERE Code='007'").fetch(:all, :Struct)
		puts products
	end

	task :acorn do
		100.times do |h|
			print "hi acorn \r"
			t = h * 2
			t.times do |p|
				print " "
			end
			sleep 0.2
		end
	end

end

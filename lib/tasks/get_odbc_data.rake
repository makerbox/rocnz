require 'rdbi-driver-odbc'

task get_odbc_data: :environment do


	puts "connecting database..."
	dbh = RDBI.connect :ODBC, :db => "roccloudy", :user => "cassy", :password => "roc", :host => "localhost"
	puts "connected."

		sth = dbh.execute("SELECT * FROM PRODUCT_MASTER")
		puts "query sent....displaying results:"
		puts "---------------------------------"
		# we know that it is definitely connecting to the database
		# we know that it is definitely finding the product_master table and the description column (changing these produce errors, so they must be correct)
		# the output is blank records [] which I believe are the result of having no license

	sth.each do |rslt|
		rslt.Description
	end

		

sth.finish

dbh.disconnect


end
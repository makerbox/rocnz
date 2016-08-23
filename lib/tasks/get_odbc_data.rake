require 'rdbi-driver-odbc'

task get_odbc_data: :environment do


	puts "connecting database..."
	dbh = RDBI.connect :ODBC, :db => "roccloudy", :user => "cassy", :password => "roc", :host => "192.168.10.1:3000"
	puts "connected."

		sth = dbh.execute("SELECT Description FROM product_master")
		puts "query sent....displaying results:"
		puts "---------------------------------"

		sth.each do |rslt|
			puts rslt
		end
		

sth.finish

dbh.disconnect


end
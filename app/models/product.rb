class Product < ActiveRecord::Base
require 'rdbi-driver-odbc'

	puts "connecting database..."
	dbh = RDBI.connect :ODBC, :db => "testroc", :user => "cassy", :password => "roc", :host => "192.168.10.72:3000"
	puts "connected."

		sth = dbh.new_statement("SELECT * FROM PRODUCT_MASTER")
		puts "query sent....displaying results:"
		puts "---------------------------------"
		# we know that it is definitely connecting to the database
		# we know that it is definitely finding the product_master table and the description column (changing these produce errors, so they must be correct)
		# the output is blank records [] which I believe are the result of having no license

		

sth.finish

dbh.disconnect
end

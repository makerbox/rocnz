# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rdbi-driver-odbc'

dbh = RDBI.connect :ODBC, :db => "testroc2"
#-----------THIS WORKS, BUT ONLY FOR LOCAL HOST - EITHER: need to configure to connect to remote computer, OR need to install on database host to populate sql database using below then remotely access sql database the easy way and then bind server to heroku ip address
codes = dbh.execute("SELECT Code FROM product_master")
	
codes.each do |code|
	if Product.where(:name == code)
		product = Product.where(:name == code).first
		product.update(name: code)
	else
		Product.create(name: code)
	end
end

codes.finish
dbh.disconnect
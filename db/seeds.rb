# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rdbi-driver-odbc'

dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
	
#-----------THIS WORKS, BUT ONLY FOR LOCAL HOST - EITHER: need to configure to connect to remote computer, OR need to install on database host to populate sql database using below then remotely access sql database the easy way and then bind server to heroku ip address
products = dbh.execute("SELECT * FROM product_master")
prodmastext = dbh.execute("select WebRecNo from prodmastext")
puts prodmastext.first

# products.each do |product|
# puts "code: " + product[1].to_s
# puts "desc: " + product[2].to_s
# puts "product group: " + product[4].to_s
# puts "purchase unit: " + product[5].to_s
# puts "in stock unit: " + product[6].to_s
# puts "sale unit: " + product[7].to_s
# puts "price cat: " + product[16].to_s
# puts "item type: " + product[21].to_s
# puts "price 1: " + product[22].to_s
# puts "price 2: " + product[23].to_s
# puts "price 3: " + product[24].to_s
# puts "price 4: " + product[25].to_s
# puts "price 5: " + product[26].to_s
# puts "price 6: " + product[27].to_s
# end

# products.each do |product|
# 	name = product[2]
# 	puts name
# 	if Product.where(:name == name)
# 		product = Product.where(:name == name).first
# 		product.update(name: name, price: price)
# 	else
# 		Product.create(name: name, price: price)
# 	end
# end

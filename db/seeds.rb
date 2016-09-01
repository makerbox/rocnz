# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rdbi-driver-odbc'

dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
	

products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
products.each do |p|
	if p.Inactive == 0
		if Product.find_by(code: p.Code)
	Product.find_by(code: p.Code).update(code: p.Code, description: p.Description, group: p.ProductGroup, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
		else
	Product.create(code: p.Code, description: p.Description, group: p.ProductGroup, price1: p.SalesPrice1, price2: p.SalesPrice2, price3: p.SalesPrice3, price4: p.SalesPrice4, price5: p.SalesPrice5, rrp: p.SalesPrice6)
#upload image to cloudinary and store url in product.imageurl (images are stored in z:/attache/roc/images/product/*sku*.jpg)
end
end
end
puts "-------------"
puts "active products:"
puts Product.count
puts "-------------"
puts "total products:"
puts products.length

activecustomers = dbh.execute("SELECT * FROM customer_mastext WHERE InactiveCust=0").fetch(:all, :Struct)
activecustomers.each do |activecustomer|
	if !Account.find_by(code: activecustomer.Code)
		Account.create(code: activecustomer.Code)
	end
end
puts "-------------"
puts "active customers:"
puts activecustomers.length
puts "-------------"
puts "accounts:"
puts Account.count

customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
customers.each do |cust|
	if Account.find_by(code: cust.Code)
	Account.find_by(code: cust.Code).update(name: cust.Name, street: cust.Street, suburb: cust.Suburb, postcode: cust.Postcode, phone: cust.Phone, contact: cust.Contact, seller_level: cust.PriceCat)
	end
	puts "brands: "
	print cust.sort
end


#customer_transactions file
#how to get which brands a customer can see?

# CUSTOMER ORDER AS SEPARATE SCAFFOLD - EACH ORDER TRANSLATED INTO KFI FILE? CAN WE INTERACT WITH THE DATABASE DIRECTLY WITHOUT KFI?

# get the fields that you need - check brief
# populate database from the required fields
# populate existing users
# make chronjob for seed
# build front end - check pricing is correct
# check sign up process works and is smooth
# build ordering process - ensure it is smooth
# build account management system for users to check invoices etc

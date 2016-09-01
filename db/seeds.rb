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

customers = dbh.execute("SELECT * FROM customer_master").fetch(:all, :Struct)
customers.last(10).each do |cust|
	puts cust.Name
	puts cust.Street
	puts cust.Suburb
	puts cust.Postcode
	puts cust.Phone
	puts cust.Fax
	puts cust.Contact
	puts cust.BusinessNum
	puts cust.Code
	puts cust.PriceCat
	puts cust.CurrentBal
end

customerexts = dbh.execute("SELECT * FROM customer_mastext").fetch(:all, :Struct)
customerexts.last(10).each do |custext|
	print "inactive? = "
puts custext.InactiveCust
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

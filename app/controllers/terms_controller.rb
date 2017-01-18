class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @time = Time.now

    @results = []

    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @datedata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)
    Product.destroy_all
    Discount.destroy_all
    @products.each do |p|
      if p.Inactive == 0
        code = p.Code.strip
        description = p.Description.to_s.strip
        price1 = p.SalesPrice1
        price2 = p.SalesPrice2
        price3 = p.SalesPrice3
        price4 = p.SalesPrice4
        price5 = p.SalesPrice5
        rrp = p.SalesPrice6
        qty = p.QtyInStock
        group = p.ProductGroup.to_s.strip
        # # needs category and image
        if Product.where(code: code)
          Product.update(code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
        else
          Product.create(code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
        end
      end
    end

    @datedata.each do |d|
      code = d.Code.strip
      Product.where(code: code).update(newdate: d.DateFld)
    end

    @time = Time.now - @time
    dbh.disconnect
  end

end

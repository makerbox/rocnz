class TermsController < ApplicationController
    skip_before_action :authenticate_user!
  def index
    @time = Time.now

    @results = []

    dbh = RDBI.connect :ODBC, :db => "wholesaleportal"

    @products = dbh.execute("SELECT * FROM product_master").fetch(:all, :Struct)
    @datedata = dbh.execute("SELECT * FROM produdefdata").fetch(:all, :Struct)

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
        # # needs category
        if Product.where(code: code).present?
          Product.where(code: code).first.update(code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "Z:\\Attache\\Roc\\Images\\Product\\" + code + '.jpg'
          if File.exist?(filename)
            Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          else
            Product.where(code: code).first.destroy
          end
        else
          Product.create(code: code, description: description, price1: price1, price2: price2, price3: price3, price4: price4, price5: price5, rrp: rrp, qty: qty)
          filename = "Z:\\Attache\\Roc\\Images\\Product\\" + code + '.jpg'
          if File.exist?(filename)
            Cloudinary::Uploader.upload(filename, :public_id => code, :overwrite => true)
          else
            Product.where(code: code).first.destroy
          end
        end
      end
    end

    @datedata.each do |d|
      code = d.Code.strip
      @results << d.Code
      @results << d.DateFld
      # Product.where(code: code).update(newdate: d.DateFld)
    end

    @time = Time.now - @time
    dbh.disconnect
  end

end

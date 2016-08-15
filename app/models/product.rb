class Product < ActiveRecord::Base
require 'rdbi-driver-odbc'
dbh = RDBI.connect :ODBC, :db => "testroc", :user => "cassy", :password => "roc", :host => "192.168.10.72:3000"
rs = dbh.execute "SELECT * FROM MY_TABLE"
rs.as(:Struct).fetch(:first)
end

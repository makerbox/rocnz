class Product < ActiveRecord::Base
require 'rdbi-driver-odbc'
dbh = RDBI.connect :ODBC, :db => "testroc", :user => "cassy", :password => "roc"
rs = dbh.execute "SELECT * FROM MY_TABLE"
rs.as(:Struct).fetch(:first)
end

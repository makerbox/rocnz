class Product < ActiveRecord::Base
	establish_connection :rocmysql
end

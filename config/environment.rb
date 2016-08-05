# Load the Rails application.
require File.expand_path('../application', __FILE__)

dbh = DBI.connect("DBI:ODBC:218.214.73.21/roctest")
# Initialize the Rails application.
Rails.application.initialize!

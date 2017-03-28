class TestController < ApplicationController
	skip_before_action :authenticate_user!
  def index
  	@result = []
  	# -------------------------GET CUSTOMERS AND ADD / UPDATE THE DB----------------------------------
  	dbh = RDBI.connect :ODBC, :db => "wholesaleportal"
  	@contacts = dbh.execute("SELECT * FROM contact_details_file").fetch(:all, :Struct)
	@contacts.each do |contact|
	  if contact.Active == 'Yes'
	    email = contact.EmailAddress
	    code = contact.Code
	    newcontact = Contact.new(email: email, code: code)
	    if thisaccount = Account.all.find_by(code: code)
	      thisaccount.user.update_attributes(email: email)
	      @result << 'found'
		else
		  @result << 'none'
	    end
	  end
	end
	dbh.disconnect

	Account.all.each do |acct|
  		@result << acct.user.email
  	end

  end
end

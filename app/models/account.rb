class Account < ActiveRecord::Base
	belongs_to :user
	has_many :mimics
	# validates :company, :phone, :state, :suburb, :street, :presence => true
end

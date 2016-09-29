class Account < ActiveRecord::Base
	belongs_to :user
	validates :company, :phone, :state, :suburb, :street, :presence => true
end

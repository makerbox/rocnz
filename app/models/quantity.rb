class Quantity < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  validates :qty, numericality: { greater_than_or_equal_to: 1 }
end

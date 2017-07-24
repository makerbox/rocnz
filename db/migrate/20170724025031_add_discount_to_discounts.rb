class AddDiscountToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :discount, :float
  end
end

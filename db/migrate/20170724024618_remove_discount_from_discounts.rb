class RemoveDiscountFromDiscounts < ActiveRecord::Migration
  def change
    remove_column :discounts, :discount, :decimal
  end
end

class RemoveDiscountFromDiscount < ActiveRecord::Migration
  def change
    remove_column :discounts, :discount, :integer
  end
end

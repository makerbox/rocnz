class RemoveDiscountFromDiscount < ActiveRecord::Migration
  def change
    remove_column :discount, :discount, :decimal
  end
end

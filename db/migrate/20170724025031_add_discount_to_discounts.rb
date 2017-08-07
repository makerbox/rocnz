class AddDiscountToDiscount < ActiveRecord::Migration
  def change
    add_column :discount, :discount, :float
  end
end

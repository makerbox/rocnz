class AddQtyToProductOrder < ActiveRecord::Migration
  def change
    add_column :product_orders, :qty, :integer
  end
end

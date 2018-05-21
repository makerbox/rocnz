class AddPriceToQuantity < ActiveRecord::Migration
  def change
    add_column :quantities, :price, :decimal
  end
end

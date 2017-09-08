class AddBrandToQuantity < ActiveRecord::Migration
  def change
    add_column :quantities, :brand, :string
  end
end

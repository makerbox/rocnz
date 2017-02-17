class AddPricecatToProduct < ActiveRecord::Migration
  def change
    add_column :products, :pricecat, :string
  end
end

class AddColumnsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :price1, :decimal
    add_column :products, :price2, :decimal
    add_column :products, :price3, :decimal
    add_column :products, :price4, :decimal
    add_column :products, :price5, :decimal
    add_column :products, :rrp, :decimal
    add_column :products, :code, :string
    add_column :products, :description, :string
    add_column :products, :group, :string
  end
end

class AddNotesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :notes, :text
    add_column :orders, :cust_order_number, :string
    add_column :orders, :order_number, :string
  end
end

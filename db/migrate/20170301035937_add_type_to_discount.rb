class AddTypeToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :type, :string
  end
end

class RemoveTypeFromDiscount < ActiveRecord::Migration
  def change
    remove_column :discounts, :type, :string
  end
end

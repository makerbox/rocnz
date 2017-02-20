class AddQtylevelToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :maxqty, :integer
    add_column :discounts, :level, :integer
  end
end

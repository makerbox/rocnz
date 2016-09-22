class AddNewdateToProduct < ActiveRecord::Migration
  def change
    add_column :products, :new_date, :date
  end
end

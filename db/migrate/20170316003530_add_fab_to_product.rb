class AddFabToProduct < ActiveRecord::Migration
  def change
    add_column :products, :fab, :string
  end
end

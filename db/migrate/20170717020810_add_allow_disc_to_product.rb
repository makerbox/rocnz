class AddAllowDiscToProduct < ActiveRecord::Migration
  def change
    add_column :products, :allow_disc, :boolean
  end
end

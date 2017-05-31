class AddBrandsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :brands, :string
  end
end

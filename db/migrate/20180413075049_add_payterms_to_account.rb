class AddPaytermsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :payterms, :string
  end
end

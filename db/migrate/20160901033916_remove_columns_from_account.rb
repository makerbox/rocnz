class RemoveColumnsFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :first_name, :string
    remove_column :accounts, :last_name, :string
    remove_column :accounts, :company, :string
    remove_column :accounts, :address, :string
  end
end

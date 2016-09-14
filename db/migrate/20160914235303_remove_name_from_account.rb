class RemoveNameFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :name, :string
  end
end

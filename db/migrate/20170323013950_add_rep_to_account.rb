class AddRepToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :rep, :string
  end
end

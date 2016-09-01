class AddColumnsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :code, :string
    add_column :accounts, :name, :string
    add_column :accounts, :contact, :string
    add_column :accounts, :street, :string
    add_column :accounts, :postcode, :string
  end
end

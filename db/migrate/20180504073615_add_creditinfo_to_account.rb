class AddCreditinfoToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :current, :decimal
    add_column :accounts, :days30, :decimal
    add_column :accounts, :days60, :decimal
    add_column :accounts, :days90, :decimal
  end
end

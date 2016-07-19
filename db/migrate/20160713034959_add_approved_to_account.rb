class AddApprovedToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :approved, :string
  end
end

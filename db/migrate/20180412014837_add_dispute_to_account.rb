class AddDisputeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :dispute, :boolean
  end
end

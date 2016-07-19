class AddApprovalToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :approval, :string
  end
end

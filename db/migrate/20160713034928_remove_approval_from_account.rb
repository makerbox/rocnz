class RemoveApprovalFromAccount < ActiveRecord::Migration
  def change
    remove_column :accounts, :approval, :string
  end
end

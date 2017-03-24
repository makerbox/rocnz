class AddSortToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :sort, :string
  end
end

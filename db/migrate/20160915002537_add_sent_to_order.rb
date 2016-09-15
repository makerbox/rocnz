class AddSentToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :sent, :datetime
  end
end

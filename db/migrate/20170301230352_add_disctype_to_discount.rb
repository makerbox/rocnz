class AddDisctypeToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :disctype, :string
  end
end

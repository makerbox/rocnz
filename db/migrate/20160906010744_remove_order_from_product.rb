class RemoveOrderFromProduct < ActiveRecord::Migration
  def change
    remove_reference :products, :order, index: true, foreign_key: true
  end
end

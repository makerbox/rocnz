class AddImageurlToProduct < ActiveRecord::Migration
  def change
    add_column :products, :imageurl, :string
  end
end

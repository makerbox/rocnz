class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :customertype
      t.string :producttype
      t.string :customer
      t.string :product
      t.integer :discount

      t.timestamps null: false
    end
  end
end

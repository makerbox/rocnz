class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

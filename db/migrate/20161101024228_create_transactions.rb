class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :prodcode
      t.string :transtype
      t.date :date
      t.integer :qty
      t.decimal :value
      t.decimal :tax
      t.text :comment
      t.string :custcode

      t.timestamps null: false
    end
  end
end

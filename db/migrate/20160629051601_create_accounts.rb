class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :company
      t.string :address
      t.string :suburb
      t.string :state
      t.string :country
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.string :seller_level

      t.timestamps null: false
    end
  end
end

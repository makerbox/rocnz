class AddPostcodeToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :postcode, :string
  end
end

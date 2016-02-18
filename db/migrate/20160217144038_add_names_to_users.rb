class AddNamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_name, :string
    add_column :users, :business_name, :string
  end
end

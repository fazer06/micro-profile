class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.references :profileable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :profiles, :name
  end
end

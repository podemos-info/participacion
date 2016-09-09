class CreateTerritories < ActiveRecord::Migration
  def change
    create_table :territories do |t|
      t.string :name
      t.integer :ccaa_id
      t.integer :province_id
      t.integer :town_id

      t.timestamps null: false
    end
  end
end

class AddCcaCounterToTags < ActiveRecord::Migration
  def change
     add_column :tags, :ccas_count, :integer, default: 0

    add_index :tags, :ccas_count
  end
end

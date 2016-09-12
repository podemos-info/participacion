class AddLawsCounterToTags < ActiveRecord::Migration
  def change
    add_column :tags, :laws_count, :integer, default: 0
    add_index :tags, :laws_count
  end
end

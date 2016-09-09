class AddExtraCounterEnquiriesToTags < ActiveRecord::Migration
  def change
    add_column :tags, :enquiries_count, :integer, default: 0
    add_index :tags, :enquiries_count
  end
end

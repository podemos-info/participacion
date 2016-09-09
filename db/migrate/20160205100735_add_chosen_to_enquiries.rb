class AddChosenToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :chosen, :boolean, default: false
  end
end

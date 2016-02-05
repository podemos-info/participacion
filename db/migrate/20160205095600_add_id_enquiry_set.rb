class AddIdEnquirySet < ActiveRecord::Migration
  def change
    add_column :enquiries, :id_enquiry_set, :integer, default: 0
  end
end

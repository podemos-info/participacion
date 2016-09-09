class CreateEnquirySets < ActiveRecord::Migration
  def change
    create_table :enquiry_sets do |t|
      t.string :front_title, limit: 80
      t.text :front_text
      t.string :button_text, limit: 20
      t.boolean :automatic_redirection, default: true
      t.datetime :start_at
      t.datetime :finish_at
      t.integer :max_chosen_enquiries, default: 10
      t.boolean :manual_selection, default: false
      t.string :body_title, limit:80
      t.text :body_text
      t.integer :territory_id
      t.integer :author_id
      t.datetime :hidden_at
      t.timestamps null: false
    end
  end
end

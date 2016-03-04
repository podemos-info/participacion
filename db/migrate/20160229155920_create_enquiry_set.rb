class CreateEnquirySet < ActiveRecord::Migration
  def change
    create_table :enquiry_sets do |t|
      t.string   "front_title", limit: 80, null: false
      t.text     "front_text", null: false
      t.string   "button_text", limit: 20, null: false
      t.boolean   "automatic_redirection", default: true
      t.datetime  "start_at", null: false
      t.datetime "finish_at", null: false
      t.integer  "max_chosen_enquiries",      default: 10
      t.boolean  "manual_selection",   default: false
      t.string "body_title", limit:80, null: false
      t.text  "body_text", null:false
      t.integer  "author_id"
      t.datetime "hidden_at"

      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "enquiry_sets", ["front_title"], name: "index_enquiry_sets_on_front_title", using: :btree
    add_index "enquiry_sets", ["body_title"], name: "index_enquiry_sets_on_body_title", using: :btree
  end
end

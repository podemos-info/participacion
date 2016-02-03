class CreateEnquiry < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.string   "title", limit: 80
      t.text     "description"
      t.string   "question"
      t.string   "external_url"
      t.integer  "author_id"
      t.datetime "hidden_at"
      t.integer  "flags_count",      default: 0
      t.datetime "ignored_flag_at"
      t.integer  "cached_votes_up",  default: 0
      t.integer  "comments_count",   default: 0
      t.datetime "confirmed_hide_at"
      t.integer  "hot_score",        limit: 8, default: 0
      t.integer  "confidence_score", default: 0

      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false

      t.string "responsible_name", limit: 60
      t.text     "summary"
      t.string   "video_url"
      t.integer  "physical_votes",               default: 0
    end

    add_index "enquiries", ["author_id", "hidden_at"], name: "index_enquiries_on_author_id_and_hidden_at", using: :btree
    add_index "enquiries", ["author_id"], name: "index_enquiries_on_author_id", using: :btree
    add_index "enquiries", ["cached_votes_up"], name: "index_enquiries_on_cached_votes_up", using: :btree
    add_index "enquiries", ["confidence_score"], name: "index_enquiries_on_confidence_score", using: :btree
    add_index "enquiries", ["hidden_at"], name: "index_enquiries_on_hidden_at", using: :btree
    add_index "enquiries", ["hot_score"], name: "index_enquiries_on_hot_score", using: :btree
    add_index "enquiries", ["question"], name: "index_enquiries_on_question", using: :btree
    add_index "enquiries", ["summary"], name: "index_enquiries_on_summary", using: :btree
    add_index "enquiries", ["title"], name: "index_enquiries_on_title", using: :btree
  end
end

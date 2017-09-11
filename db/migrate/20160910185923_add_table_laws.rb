class AddTableLaws < ActiveRecord::Migration
  def change

    create_table "laws", force: :cascade do |t|
    t.string   "title",                        limit: 800
    t.text     "description"
    t.integer  "author_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "visit_id"
    t.datetime "hidden_at"
    t.integer  "flags_count",                             default: 0
    t.datetime "ignored_flag_at"
    t.integer  "cached_votes_total",                      default: 0
    t.integer  "cached_votes_up",                         default: 0
    t.integer  "cached_votes_down",                       default: 0
    t.integer  "comments_count",                          default: 0
    t.datetime "confirmed_hide_at"
    t.integer  "cached_anonymous_votes_total",            default: 0
    t.integer  "cached_votes_score",                      default: 0
    t.integer  "hot_score",                    limit: 8,  default: 0
    t.integer  "confidence_score",                        default: 0
  end

  add_index "laws", ["author_id", "hidden_at"], name: "index_laws_on_author_id_and_hidden_at", using: :btree
  add_index "laws", ["author_id"], name: "index_laws_on_author_id", using: :btree
  add_index "laws", ["cached_votes_down"], name: "index_laws_on_cached_votes_down", using: :btree
  add_index "laws", ["cached_votes_score"], name: "index_laws_on_cached_votes_score", using: :btree
  add_index "laws", ["cached_votes_total"], name: "index_laws_on_cached_votes_total", using: :btree
  add_index "laws", ["cached_votes_up"], name: "index_laws_on_cached_votes_up", using: :btree
  add_index "laws", ["confidence_score"], name: "index_laws_on_confidence_score", using: :btree
  add_index "laws", ["hidden_at"], name: "index_laws_on_hidden_at", using: :btree
  add_index "laws", ["hot_score"], name: "index_laws_on_hot_score", using: :btree
  add_index "laws", ["title"], name: "index_laws_on_title", using: :btree

  end
end

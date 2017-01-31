class CreateCcas < ActiveRecord::Migration
  def change
    create_table :ccas do |t|
      t.string :title, limit: 80
      t.text :description
      t.integer :author_id
      t.timestamps null: false
      t.string :visit_id
      t.integer :flags_count, default: 0
      t.datetime :ignored_flag_at
      t.datetime :hidden_at
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0
      t.integer :comments_count, default: 0
      t.datetime :confirmed_hide_at
      t.integer :cached_anonimous_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
      t.bigint :hot_score, default: 0
      t.integer :confidence_score, default: 0
      t.integer :ccaa_id, default: 0
    end

    add_index :ccas, :hidden_at
    add_index :ccas, :cached_votes_total
    add_index :ccas, :cached_votes_up
    add_index :ccas, :cached_votes_down
    add_index :ccas, :cached_votes_score
    add_index :ccas, :hot_score
    add_index :ccas, :confidence_score
    add_index :ccas, :author_id
    add_index :ccas, [:author_id, :hidden_at]
    add_index :ccas, :title
  end
end

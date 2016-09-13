class ChangeSizeLawTitle < ActiveRecord::Migration
  def change
    #ALTER TABLE laws ALTER FIELD title
    execute "ALTER TABLE laws ALTER COLUMN title TYPE VARCHAR(800)"
    change_column :laws, :title, :string, limit: 800
  end
end

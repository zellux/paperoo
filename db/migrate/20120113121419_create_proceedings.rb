class CreateProceedings < ActiveRecord::Migration
  def change
    create_table :proceedings do |t|
      t.string :title
      t.integer :year
      t.string :booktitle

      t.timestamps
    end
  end
end

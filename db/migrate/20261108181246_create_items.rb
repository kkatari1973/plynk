class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.references :category,
                    null: false,
                    foreign_key: true,
                    index: true

      t.string :title, null: false
      t.string :creator
      t.text :description
      t.jsonb :details, null: false, default: {}

      t.timestamps
    end

    add_index :items, :title
    add_index :items, [ :category_id, :title ]
  end
end

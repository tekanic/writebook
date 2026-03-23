class CreatePublicationBrandings < ActiveRecord::Migration[8.0]
  def change
    create_table :publication_brandings do |t|
      t.references :book, null: false, foreign_key: true, index: { unique: true }
      t.string :accent_color, default: "#0066cc"
      t.string :from_name
      t.string :tagline
      t.text :footer_text
      t.json :social_links, default: {}
      t.string :font_family, default: "Arial"
      t.timestamps
    end
  end
end

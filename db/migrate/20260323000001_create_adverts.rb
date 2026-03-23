class CreateAdverts < ActiveRecord::Migration[8.0]
  def change
    create_table :adverts do |t|
      t.string :headline, null: false
      t.text :body_text
      t.string :destination_url
      t.string :cta_text, default: "Learn more"
      t.string :advertiser_name
      t.string :status, default: "draft"
      t.timestamps
    end
  end
end

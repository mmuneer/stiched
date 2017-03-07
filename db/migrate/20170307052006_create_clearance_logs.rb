class CreateClearanceLogs < ActiveRecord::Migration
  def change
    create_table :clearance_logs do |t|
      t.integer :item_id
      t.text :message

      t.timestamps null: false
    end
  end
end

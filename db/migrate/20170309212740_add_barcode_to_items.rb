class AddBarcodeToItems < ActiveRecord::Migration
  def change
    add_column :items, :barcode, :text
  end
end

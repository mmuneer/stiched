require 'csv'
require 'ostruct'
module Clearance
  module Processors
    class BatchProcessor

      def process(uploaded_file, validator)
        clearancing_status = create_clearancing_status
        CSV.foreach(uploaded_file, headers: false) do |row|
          potential_item_id = row[0].to_i
          clearancing_error = validator.error(potential_item_id)
          if clearancing_error
            clearancing_status.errors << clearancing_error
          else
            clearancing_status.item_ids_to_clearance << potential_item_id
          end
        end

        clearance_items!(clearancing_status)
      end

      private

      def clearance_items!(clearancing_status)
        if clearancing_status.item_ids_to_clearance.any?
          Item.transaction do
            clearancing_status.clearance_batch.save!
            clearancing_status.item_ids_to_clearance.each do |item_id|
              item = Item.find(item_id)
              item.clearance!
              clearancing_status.clearance_batch.items << item
            end
          end
        end
        clearancing_status
      end

      def create_clearancing_status
        OpenStruct.new(
            clearance_batch: ClearanceBatch.new,
            item_ids_to_clearance: [],
            errors: [])
      end
    end
  end
end
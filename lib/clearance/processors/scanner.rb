require 'ostruct'
module Clearance
  module Processors
    class Scanner

      def process(barcode, validator)
        clearancing_status = create_clearancing_status
        clearancing_error = validator.error(barcode)
        return status(clearancing_status, false, { message: clearancing_error }) if clearancing_error
        item = clearance!(barcode)
        return status(clearancing_status, true, { item_id: item.id })
      end

      private

      def status(obj, success, opts={})
        obj.success = success
        obj.message = opts[:message] if opts.key?(:message)
        obj.item_id = opts[:item_id] if opts.key?(:item_id)
        return obj
      end

      def clearance!(barcode)
        item = Item.where(barcode: barcode).first
        item.clearance!
        return item
      end

      def create_clearancing_status
        OpenStruct.new(
            item_id: nil,
            success: false,
            message: nil)
      end

    end
  end
end
require 'ostruct'
module Clearance
  module Processors
    class Scanner

      def process(barcode, validator)
        clearancing_status = create_clearancing_status
        clearancing_error = validator.error(barcode)
        return status(clearancing_status, false, clearancing_error) if clearancing_error
        clearance!(barcode)
        return status(clearancing_status, true)
      end

      private

      def status(obj, status, message=nil)
        obj.success = status
        obj.message = message
        return obj
      end

      def clearance!(barcode)
        item = Item.where(barcode: barcode).first
        item.clearance!
      end

      def create_clearancing_status
        OpenStruct.new(
            success: false,
            message: '')
      end

    end
  end
end
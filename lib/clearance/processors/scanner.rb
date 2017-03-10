require 'ostruct'
module Clearance
  module Processors
    class Scanner

      def self.process(barcode)
        clearancing_status = create_clearancing_status
        clearancing_error = what_is_the_clearancing_error?(barcode)
        return status(clearancing_status, false, clearancing_error) if clearancing_error
        clearance!(barcode)
        return status(clearancing_status, true)
      end

      private

      def self.status(obj, status, message=nil)
        obj.success = status
        obj.message = message
        return obj
      end

      def self.clearance!(barcode)
        item = Item.where(barcode: barcode).first
        item.clearance!
      end

      def self.create_clearancing_status
        OpenStruct.new(
            success: false,
            message: '')
      end

    end
  end
end
module Clearance
  module Validators
    class ScanValidator
      def error(potential_barcode)
        if potential_barcode.blank? ||  !potential_barcode.is_a?(String)
          return "Barcode #{potential_barcode} is not valid"
        end
        if Item.where(barcode: potential_barcode).none?
          return "Barcode #{potential_barcode} could not be found"
        end
        if Item.sellable.where(barcode: potential_barcode).none?
          return "Barcode #{potential_barcode} could not be clearanced"
        end

        return false
      end
    end
  end
 end
module Clearance
  module Validators
    class BatchValidator

      def error(potential_item_id)
        if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
          return "Item id #{potential_item_id} is not valid"
        end
        if Item.where(id: potential_item_id).none?
          return "Item id #{potential_item_id} could not be found"
        end
        if Item.sellable.where(id: potential_item_id).none?
          return "Item id #{potential_item_id} could not be clearanced"
        end

        return false
      end
    end
  end
end
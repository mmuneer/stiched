class ClearancingService
  attr_reader :processor, :data, :validator

  def initialize(processor, validator, data)
    @processor = processor
    @validator = validator
    @data = data
  end

  def process
    processor.process(data, validator)
  end

  # Batches up all the manually scanned items and adds them to a clearance batch
  def self.create_clearance_batch_for_scanned_items
    batch = ClearanceBatch.new
    items_to_be_clearanced = Item.clearanced.by_batch(nil)
    items_to_be_clearanced.each  { |item| batch.items << item }
    return batch if batch.save!
    rescue
      raise "Could not create batch!!"
  end

end

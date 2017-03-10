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

end

class ClearancingService
  attr_reader :processor, :data

  def initialize(processor_type, data)
    begin
      @processor = Clearance::Processors.const_get(processor_type)
      @data = data
    rescue
      raise "Unknown processor #{processor_type}"
    end
  end

  def process
    processor.process(data)
  end

end

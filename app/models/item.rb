class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")
  SELLABLE = 'sellable'
  CLEARANCED = 'clearanced'
  SOLD = 'sold'
  NOT_SELLABLE = 'not_sellable'

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: SELLABLE) }
  scope :clearanced, -> { where(status: CLEARANCED) }
  scope :by_batch, ->(id) { where(clearance_batch_id: id)}


  def clearance!
    update_attributes!(status: 'clearanced', 
                       price_sold: style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE)
  end

end

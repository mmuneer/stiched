FactoryGirl.define do
  factory :clearance_batch do

  end

  factory :item do
    style
    color "Blue"
    size "M"
    status "sellable"
    barcode "barcode"
  end

  factory :style do
    wholesale_price 55
  end
end

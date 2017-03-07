FactoryGirl.define do  factory :clearance_log do
    item_id 1
message "MyText"
  end


  factory :clearance_batch do

  end

  factory :item do
    style
    color "Blue"
    size "M"
    status "sellable"
  end

  factory :style do
    wholesale_price 55
  end
end

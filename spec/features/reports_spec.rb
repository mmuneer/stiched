require "rails_helper"

describe 'clearancing reports' do
  let!(:clearance_batch_1) { FactoryGirl.create(:clearance_batch) }
  let!(:item) { FactoryGirl.create(:item, clearance_batch_id: clearance_batch_1.id, status: 'clearanced')}
  it 'lists all the reports' do
    visit "/reports/successful_clearances?batch_id=#{clearance_batch_1.id}"
    expect(page).to have_content("Stitch Fix Clearance Tool")
    within('table.clearance_batches') do
      expect(page).to have_content("#{item.id}")
      expect(page).to have_content("#{item.color}")
      expect(page).to have_content("#{item.size}")
    end
  end

end
require 'rails_helper'

RSpec.describe HoursPresenter, type: :model do
  context "with all hours" do
    let!(:business) {create(:business)}

    before do
      prep_business_hours(business)
      @presenter = HoursPresenter.new(business.hours)
      Timecop.freeze(Time.local(2017,1,25,22,8,18))
    end

    after do
      Timecop.return
    end

    specify { expect { |b| @presenter.each_with_hour_order(&b) }.to yield_control.exactly(7).times }

    it "displays hours correctly" do
      expect(@presenter.display_hours).to include "<strong>Mon</strong> 10:00 am - 09:00 pm"
      expect(@presenter.display_hours).to include "<strong>Sat</strong> 10:00 am - 09:00 pm"
      expect(@presenter.display_hours).to include "<strong>Wed</strong> 10:00 am - 09:00 pm\n<span class=\"text-danger lead\"> Closed now</span>"
    end
  end

  def prep_business_hours(business)
    (0..6).each do |i|
      create(:biz_hour, day: i, business: business)
    end
  end
end

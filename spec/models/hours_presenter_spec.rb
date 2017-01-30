require 'rails_helper'

RSpec.describe HoursPresenter, type: :model do
  context "with all hours" do
    let!(:business) {create(:business, :with_ungeocoded_address, :with_lat_lng)}

    before do
      prep_business_hours(business)
      @presenter = HoursPresenter.new(business.hours, business.timezone_for_time_settings)
      Timecop.freeze(Time.local(2017,1,25,20,8,18))
    end

    after do
      Timecop.return
    end

    specify { expect { |b| @presenter.each_with_hour_order(&b) }.to yield_control.exactly(7).times }

    it "displays hours correctly" do
      expect(@presenter.display_hours).to include "<strong>Mon</strong> 10:00 am - 09:00 pm"
      expect(@presenter.display_hours).to include "<strong>Sat</strong> 10:00 am - 09:00 pm"
      expect(@presenter.display_hours).to include "<strong>Wed</strong> 10:00 am - 09:00 pm\n<span class=\"text-success lead\"> Open now</span>"
    end

    it "displays hours correctly in a different timezone" do
      business.update_attributes!(state: "DC")
      business.hours.update_all(timezone: 3, open_at: "10:00:00-05", close_at: "21:00:00-05")
      @presenter = HoursPresenter.new(business.reload.hours, business.reload.timezone_for_time_settings)
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

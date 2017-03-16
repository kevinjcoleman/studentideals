require 'rails_helper'

RSpec.describe BizHour, type: :model do
  it { should belong_to(:business) }
  it { should validate_presence_of(:day) }
  it { should validate_presence_of(:open_at) }
  it { should validate_presence_of(:business) }
  it { should validate_presence_of(:close_at) }

  context ".scopes" do
    let!(:business) {create(:business)}
    let!(:ten_to_twenty_one) {create(:biz_hour, business: business)}
    describe "hours_between" do
      context "within" do
        it "opens between" do
          expect(BizHour.hours_between("20:00:00-08", "22:00:00-08").any?).to be_truthy
        end

        it "closes between" do
          expect(BizHour.hours_between("6:00:00-08", "14:00:00-08").any?).to be_truthy
        end

        it "whole hours between" do
          expect(BizHour.hours_between("11:00:00-08", "14:00:00-08").any?).to be_truthy
        end

        it "checks for the start & end of the day" do
          expect(BizHour.hours_between("00:00:00-08", "23:59:00-08").any?).to be_truthy
        end
      end

      context "outside" do
        it "hours before" do
          expect(BizHour.hours_between("6:00:00-08", "9:00:00-08").any?).to be_falsey
        end

        it "hours after" do
          expect(BizHour.hours_between("22:00:00-08", "23:00:00-08").any?).to be_falsey
        end
      end
    end
  end
end

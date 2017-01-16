require 'rails_helper'

RSpec.describe BizHour, type: :model do
  it { should belong_to(:business) }
  it { should validate_presence_of(:day) }
  it { should validate_presence_of(:open_at) }
  it { should validate_presence_of(:business) }
  it { should validate_presence_of(:close_at) }
end

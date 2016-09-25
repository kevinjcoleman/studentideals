require 'rails_helper'

RSpec.describe Deal, type: :model do
  it { should belong_to(:business) }
  it { should validate_presence_of(:desc_short) }
end

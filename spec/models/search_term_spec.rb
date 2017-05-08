require 'rails_helper'

RSpec.describe SearchTerm, type: :model do
  let!(:business) { create(:business) }
  let!(:term) { "Happy Hour" }
  describe "add_search_term" do
    context "non existing search term" do
      before {SearchTerm.add_search_term(term, business)}
      it 'creates search term' do
        expect(SearchTerm.first.term).to eq(term)
      end

      it "adds association" do
        expect(business.search_terms.first.term).to eq(term)
      end
    end

    context "existing term" do
      before do
        create(:search_term, term: term)
        SearchTerm.add_search_term(term, business)
      end
      it 'doesn\'t create a new search term' do
        expect(SearchTerm.count).to eq(1)
      end

      it "adds association" do
        expect(business.search_terms.first.term).to eq(term)
      end
    end
  end
end

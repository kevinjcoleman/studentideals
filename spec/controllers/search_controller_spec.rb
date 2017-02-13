require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  let!(:region) {create(:region, name: "test region")}
  let!(:sid_category) {create(:sid_category, label: "test sid_category")}
  let!(:sub_category) {create(:sub_category, label: "test sub_category", sid_category: sid_category)}
  let!(:business) {create(:business, :with_ungeocoded_address, :with_lat_lng, biz_name: "test business")}

  describe "GET #results" do
    context "it's successful with random query" do
      before { get :results, query: "random query" }
      it { should respond_with(:success) }
    end
  end

  describe "GET redirect" do
    let!(:blank_params) { {bizCat: nil,
                           bizCatType: nil,
                           location: nil,
                           bizCatTerm: nil,
                           currentLocationValue: nil}}
    context "with region and bizCat" do
      let!(:region_params)  {blank_params.merge(location: region.id)}

      context "business" do
        let(:params) {region_params.merge(biz_cat_params(business))}

        before { get :redirect, params }
        it { should redirect_to business_path(business) }
      end

      context "sid_category" do
        let(:params) {region_params.merge(biz_cat_params(sid_category))}

        before { get :redirect, params }
        it { should redirect_to region_and_category_path(region, sid_category) }
      end

      context "sub_category" do
        let(:params) {region_params.merge(biz_cat_params(sub_category))}

        before { get :redirect, params }
        it { should redirect_to region_category_and_subcategory_path(region, sid_category, sub_category) }
      end
    end

    context "with just a biz cat" do
      context "business" do
        let(:params) {blank_params.merge(biz_cat_params(business))}

        before { get :redirect, params }
        it { should redirect_to business_path(business) }
      end

      context "sid_category" do
        let(:params) {blank_params.merge(biz_cat_params(sid_category))}

        before { get :redirect, params }
        it { should redirect_to category_path(sid_category) }
      end

      context "sub_category" do
        let(:params) {blank_params.merge(biz_cat_params(sub_category))}

        before { get :redirect, params }
        it { should redirect_to category_and_subcategory_path(sid_category, sub_category) }
      end
    end

    context "with just a region" do
      let(:params) {blank_params.merge(location: region.id)}

      before { get :redirect, params }
      it { should redirect_to region_path(region) }
    end

    context "with region and bizCatTerm" do

    end

    context "with both a currentLocationValue & bizCatTerm" do

    end

    context "with just bizCatTerm" do

    end

    context "with just a currentLocationValue" do

    end

    context "with no values" do
      before { get :redirect, blank_params }
      it { should redirect_to root_path }
      it { should set_flash[:danger].to('You must provide a search term.') }
    end
  end

  def biz_cat_params(instance)
    {bizCat: instance.id, bizCatType: instance.class.name}
  end
end

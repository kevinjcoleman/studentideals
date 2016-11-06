require 'rails_helper'

RSpec.describe RegionController, type: :controller do
  let!(:region) {create(:region)}
  let!(:union_station) {create(:region, name: "Union Station")}
  let!(:other_region) {create(:region, name: "Other region")}

  describe "GET #show" do
    before {get :show, id: region.id}
    
    it { should respond_with(:success) }
    it { should render_template('show') }
    
    it "assigns the correct region" do
      expect(assigns(:region)).to eq(region)
    end
  end

  describe "GET #index" do
    context "exact match" do 
      before {get :index, region_name: "Union Station"}
      it { should respond_with(:redirect) }
      it { should redirect_to(region_path(union_station)) }
    end

    context "multipe matches" do 
      before {get :index, region_name: "U"}
      it { should respond_with(:success) }
      it { should render_template('index') } 
      it "assigns the matching regions" do
        expect(assigns(:regions)).to eq([region, union_station])
      end
    end

    context "no matches" do 
      before {get :index, region_name: "B"}
      it { should respond_with(:success) }
      it { should render_template('index') } 
      it "assigns all regions" do
        expect(assigns(:regions)).to eq([region, union_station, other_region])
      end
    end

    context "no query" do 
      before {get :index}
      it { should respond_with(:success) }
      it { should render_template('index') } 
      it "assigns all regions" do
        expect(assigns(:regions)).to eq([region, union_station, other_region])
      end
    end
  end
end

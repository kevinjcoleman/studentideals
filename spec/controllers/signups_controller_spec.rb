require 'rails_helper'

RSpec.describe SignupsController, type: :controller do

  describe "POST #create" do
    context "with no email" do
      before {post :create, signup: {email: ''}, format: :js}

      it { should respond_with(:success) }

      it "does not create a signup" do
        expect(Signup.count).to eq(0)
      end
    end

    context "with an email" do

      context "correctly formatted email" do
        before {post :create, signup: {email: 'student@school.edu'}, format: :js}

        it "should flash notice" do
          expect(flash[:notice]).to eq("Succesfully joined!")
        end

        it "does creates a signup" do
          expect(Signup.count).to eq(1)
        end

        it { should respond_with(:success) }
      end

      context "incorrectly formatted email" do
        before {post :create, signup: {email: 'student'}, format: :js}

        it "doesn't creates a signup" do
          expect(Signup.count).to eq(0)
        end

        it { should respond_with(:success) }
      end
    end
  end
end

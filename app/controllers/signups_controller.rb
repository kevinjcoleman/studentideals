class SignupsController < ApplicationController
  def create
    @signup = Signup.new(signup_params)
    respond_to do |format|
      if @saved = @signup.save
        format.js { flash.now[:notice] = "Succesfully joined!" }
      else
        format.js { flash.now[:danger] = "<strong>Something went wrong</strong>" }
      end
    end
  end

  def signup_params
    params.require(:signup).permit(:email)
  end
end

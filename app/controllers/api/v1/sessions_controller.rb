require 'pry-byebug'

module Api::V1
  class SessionsController < Devise::SessionsController
    # For some reason the Devise verify_signed_out_user before_filter returns
    # success and doesn't call the destroy method.
    skip_filter :verify_signed_out_user

    # Thanks! https://github.com/Sjors/devise-token-api-demo/blob/master/app/controllers/sessions_controller.rb
    # DELETE /resource/sign_out
    def destroy
      if current_user
        current_user.update authentication_token: nil
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        render :json => {}, :status => :ok
      else
        render :json => { error: User.new.unauthenticated_message}, :status => :unauthorized
      end
    end
  end
end

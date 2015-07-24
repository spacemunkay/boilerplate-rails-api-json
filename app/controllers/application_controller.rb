class ApplicationController < ActionController::API
  # Necessary for gem: active_model_serializers
  # include ActionController::Serialization

  include ActionController::MimeResponds
  include ActionController::ImplicitRender

  acts_as_token_authentication_handler_for User

  respond_to :json
end

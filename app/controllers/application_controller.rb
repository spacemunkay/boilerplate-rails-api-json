class ApplicationController < ActionController::API
  # Necessary for gem: active_model_serializers
  # include ActionController::Serialization

  include ActionController::MimeResponds
  include ActionController::ImplicitRender

  respond_to :json
end

# frozen_string_literal: true

class ApplicationController < ActionController::API

  before_action :authenticate_resource!

  private

  def render_error(message, status)
    render json: { errors: message }, status: status
  end

  def authenticate_resource!
    header = request.headers["Authorization"]
    header = header.split.last if header

    begin
      decoded = Auths::JsonWebToken.decode(header)
      @current_resource = decoded[:resource_type]
        .constantize
        .find(decoded[:resource_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render_error(e.message, :unauthorized)
    end
  end

end

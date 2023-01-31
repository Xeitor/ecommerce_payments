class ApplicationController < ActionController::API
  before_action :validate_user

  rescue_from ::Exception do |exception|
    render_error :server_error
  end

  rescue_from Mongoid::Errors::DocumentNotFound do |_exception|
    render_error :not_found
  end

  def render_error(error_code, errors = {})
    status, msg = case error_code
                  when :invalid          then [400, 'Invalid record']
                  when :unauthorized     then [401, 'Unauthorized']
                  when :payment_required then [402, 'Payment Required']
                  when :not_found        then [404, 'Record not found']
                  when :cannot_apply     then [412, 'Can not be applied']
                  when :server_error     then [500, 'Server error']
                  end

    render json: {
      status: status,
      message: msg,
      errors: errors
    }
  end

  private

  def validate_user
    Current.user = TokenService.validate_user(token)
    render_error :unauthorized unless Current.user
  rescue TokenService::AuthorizationError => e
    render_error :unauthorized
  rescue StandardError => e
    render_error :server_error
  end

  def token
    request.headers['Authorization'].match(/bearer (.+)/).captures.first
  end

  def record_not_found(error)
    render json: { error: }, status: :not_found
  end
end

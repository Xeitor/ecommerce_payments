class ApplicationController < ActionController::API
  rescue_from ::Exception do |exception|
    puts exception
    render_error :server_error
  end

  rescue_from Mongoid::Errors::DocumentNotFound do |_exception|
    render_error :not_found
  end


  # before_action :validate_user
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
      status:,
      message: msg,
      errors:
    }
  end

  private

  def record_not_found(error)
    render json: { error: err }, status: :not_found
  end 
end

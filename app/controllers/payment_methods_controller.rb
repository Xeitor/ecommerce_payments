class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: %i[show update destroy]

  # GET /payment_methods
  def index
    @payment_methods = PaymentMethod.where(user_id: Current.user.id)

    render json: @payment_methods.as_json(methods: :id)
  end

  # GET /payment_methods/1
  def show
    render json: @payment_method
  end

  # POST /payment_methods
  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    @payment_method.user_id = Current.user.id

    if @payment_method.save
      render json: @payment_method, status: :created, location: @payment_method
    else
      render json: @payment_method.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payment_methods/1
  def destroy
    if @payment_method.destroy
      render json: {}, status: 200
    else
      render_error :invalid, @payment_method.errors
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def payment_method_params
    params.require(:payment_method).permit(:card_number,
                                           :expiration_date,
                                           :security_code,
                                           :card_holder_name,
                                           :issuer)
  end
end

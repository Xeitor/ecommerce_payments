class Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations
  include Mongoid::Enum

  ##############################################################################
  # ASSOCIATIONS
  ##############################################################################
  belongs_to :payment_method

  ##############################################################################
  # FIELDS
  ##############################################################################
  field :payment_date, type: Date
  field :order_id, type: String
  field :user_id, type: String
  field :amount, type: Float
  field :state, type: Integer
  field :payment_errors, type: String

  enum :state, %i[success fail]

  ##############################################################################
  # FIELDS VALIDATIONS
  ##############################################################################
  validates :order_id, :amount, presence: true
  validates :order_id, uniqueness: true # solo puede haber un pago por order
  validate :payment_method_belongs_to_user

  def payment_method_belongs_to_user
    return if payment_method&.user_id == user_id

    errors.add("payment_method_id", "payment_method_id does not belong to user")
  end

  def process_payment
    state = PaymentProcesor.process(self)
    case state
    when :success
      update(state: :success, payment_date: Time.now)
    when :fail
      update(state: :fail, payment_errors: 'ErrorProccesingPayment')
    end
  end
end

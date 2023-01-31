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
  # validates :order_id, uniqueness: { scope: :user } # solo puede haber un pago por order
  # validate payment_method belongs to defined user
  # validates :payment_method_belongs_to_user

  def process_payment
    return if persisted?

    state = PaymentProcesor.process(self)
    case state
    when :success
      update(state: :success, payment_date: Time.now)
    when :fail
      update(state: :fail, payment_errors: 'Error Proccesing payment')
    end
  end
end

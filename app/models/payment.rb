class Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  ##############################################################################
  # FIELDS
  ##############################################################################

  field :user_id, type: String
  field :order_id, type: String
  field :amount, type: Float
  field :state, type: Integer

  enum state: {
    approved: 0,
    proccesing: 1,
    error: 2
  }

  has_one :payment_method
  ##############################################################################
  # FIELDS VALIDATIONS
  ##############################################################################
  validates :user_id, :order_id, :amount, :payment_method, presence: true
  # validate payment_method belongs to defined user
end

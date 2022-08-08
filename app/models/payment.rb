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

  ##############################################################################
  # FIELDS VALIDATIONS
  ##############################################################################
  validates :user_id, :order_id, :amount, presence: true
end

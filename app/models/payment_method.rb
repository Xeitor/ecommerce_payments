class PaymentMethod
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  ##############################################################################
  # FIELDS
  ##############################################################################

  field :card_number, type: String
  field :expiration_date, type: Date
  field :security_code, type: Integer
  field :card_holder_name, type: String
  field :issuer, type: String
  field :user_id, type: String
  field :active, type: Boolean

  before_create :set_active_to_true

  def set_active_to_true
    self.active = true
  end

  ##############################################################################
  # FIELDS VALIDATIONS
  ##############################################################################
  validates :card_number, :expiration_date, :security_code, :card_holder_name,
            :issuer, :user_id, presence: true
  def id
    _id.to_s
  end

  def destroy
    update!(active: false)
  end
end

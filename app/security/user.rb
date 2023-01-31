class User
  attr_accessor :id, :name, :permissions, :login

  def initialize(id:, name:, permissions:, login:)
    @id          = id
    @name        = name
    @login       = login
    @permissions = permissions
  end
end


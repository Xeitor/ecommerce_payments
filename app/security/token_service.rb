class TokenService
  class AuthorizationError < StandardError
  end
  @cached_users = ActiveSupport::Cache::FileStore.new(Rails.root.join('tmp', 'cache'), expires_in: 1.day)

  def self.validate_user(token)
    user = @cached_users.read(token)
    return user if user # estaba en cache

    user = retrieve_user(token)
    raise AuthorizationError unless user

    @cached_users.write(token, user)
    user
  end

  def self.invalidate(token)
    @cached_users.delete(token)
  end

  def self.retrieve_user(token)
    conn = Faraday.new(
      url: ENV['AUTH_SERVICE_URL'],
      headers: { 'Authorization' => "bearer #{token}" }
    )
    response = conn.get('/v1/users/current')
    return if response.status != 200
    return unless response.body

    user_attrs_hash = JSON.parse(response.body).deep_symbolize_keys
    User.new(**user_attrs_hash)
  rescue StandardError => e
    puts e
    nil
  end
end

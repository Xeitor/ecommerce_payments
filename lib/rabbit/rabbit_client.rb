class Rabbit::RabbitClient
  require 'bunny'
  attr_accessor :exchange,
                :rabbit_channel,
                :connection

  def initialize
    create_connection
    set_channel
  end

  def create_connection
    conn = Bunny.new(host: ENV['RABBIT_HOST'], user: ENV['RABBIT_USER'], password: ENV['RABBIT_PASSWORD'])
    conn.start
    self.connection = conn
  end

  def set_channel
    puts "Set Channel: #{connection.status}"
    try(:close_channel)
    @rabbit_channel = connection.create_channel
    @rabbit_channel
  end

  def channel
    open? ? @rabbit_channel : set_channel
  end

  def close
    @rabbit_channel.close if defined?(@rabbit_channel)
    connection.close if connection.present?
  rescue Bunny::ChannelAlreadyClosed
    nil
  end

  def close_channel
    @rabbit_channel.close if defined?(@rabbit_channel)
  end

  def status
    {
      connection: connection.status,
      channel: @rabbit_channel.status
    }
  end

  def open?
    (connection.status == :open) &&
      (@rabbit_channel.status == :open)
  end

  def connection_openned?
    [:open, :connecting, :connected].include?(connection.status)
  end
end

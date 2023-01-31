class Rabbit::DirectConsumer
  attr_accessor
  def initialize(queue, exchange)
    @queue         = queue
    @rabbit_client = RabbitClient.new
  end

  def consume
    @rabbit_client
  end
end

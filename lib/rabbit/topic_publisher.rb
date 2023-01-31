class Rabbit::TopicPublisher
  def channel
    @rabbit_client.channel
  end

  def close
    @rabbit_client.channel.close
  end

  def self.publish(routing_key:, exchange_name:, message:)
    exchange = Rabbit::RabbitClient.new.channel.topic(exchange_name)
    exchange.publish(message.to_json, routing_key: routing_key)
  end
end

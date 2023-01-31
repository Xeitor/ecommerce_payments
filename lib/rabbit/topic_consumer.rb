class Rabbit::TopicConsumer
  # No necesitan queue solo exchange
  def initialize(exchange: nil, queue: nil, routing_key: nil)
    @queue_name    = queue
    @routing_key   = routing_key
    @exchange_name = exchange
    @rabbit_client = Rabbit::RabbitClient.new
  end

  def channel
    @rabbit_client.channel
  end

  def close
    @rabbit_client.channel.close
  end

  def consume
    exchange = channel.topic(@exchange_name || '')
    queue = channel.queue(@queue_name || 'payments', auto_delete: true)
    puts "[*] Topic: Waiting for messages: Exchange: #{exchange}"
    queue.bind(exchange, routing_key: @routing_key).subscribe(block: true) do |delivery_info, metadata, payload|
      puts " [x] Topic Received #{payload}"
      yield(delivery_info, metadata, payload)
    end
  rescue Interrupt => e
    close
    exit(0)
  end
end

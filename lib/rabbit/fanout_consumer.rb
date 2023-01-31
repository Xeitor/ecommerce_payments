class Rabbit::FanoutConsumer
  # No necesitan queue solo exchange
  def initialize(exchange: nil, queue: nil)
    @queue_name    = queue
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
    exchange = channel.fanout(@exchange_name || '')
    queue = channel.queue(@queue_name || 'payments', auto_delete: true)
    puts "[*] Fanout: Waiting for messages: Exchange: #{exchange}"
    queue.bind(exchange).subscribe(block: true) do |delivery_info, metadata, payload|
      puts " [x] Received #{payload}"
      yield(delivery_info, metadata, payload)
    end
  rescue Interrupt => e
    close
    exit(0)
  end
end

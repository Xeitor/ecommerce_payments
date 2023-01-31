namespace :consumer do
  task consume_auth_fanout: :environment do
    Rabbit::FanoutConsumer.new(exchange: 'auth').consume do |_delivery_info, _metadata, message|
      message = JSON.parse(message).deep_symbolize_keys
      RabbitController.exec_action(message)
    end
  end
  task consume_order_placed: :environment do
    Rabbit::TopicConsumer.new(exchange: 'sell_flow', routing_key: 'order_validated', queue: 'payments_sell_flow')
                         .consume do |_delivery_info, _metadata, message|
      message = JSON.parse(message).deep_symbolize_keys
      RabbitController.exec_action(message)
    end
  end
end

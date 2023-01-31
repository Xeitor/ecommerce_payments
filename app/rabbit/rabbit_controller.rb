class RabbitController
  def self.logout(message)
    token = message.match(/bearer (.+)/).captures.first
    TokenService.invalidate(token)
  end

  def self.order_validated(message)
    payment_data = {
      order_id: message[:orderId],
      payment_method_id: message[:paymentMethodId],
      amount: message[:totalAmount],
      user_id: message[:userId]
    }
    payment = Payment.find_or_initialize_by(order_id: payment_data[:order_id])
    payment.process_payment

    message = {
      type: 'payment_state_update',
      message: {
        orderId: payment.order_id.to_s,
        paymentId: payment.id.to_s,
        paymentState: payment.state,
        paymentErrors: payment.payment_errors
      }
    }

    Rabbit::TopicPublisher.publish(exchange_name: 'sell_flow', routing_key: 'payment_state_update', message:)
  end

  def self.exec_action(message)
    send(message[:type].underscore, message[:message])
  end
end

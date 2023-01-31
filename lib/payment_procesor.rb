class PaymentProcesor
  def self.process(payment)
    # Lógica de procesamiento de un pago.....
    puts "Processing payment: #{payment}"
    %i[success fail].sample
  end
end

# Payments Service en RoR

Servicio desarrollado utilizando el framework Ruby on Rails. Se encarga de mantener los métodos de pagos de los usuarios y realizarlos una vez que se validan una Order.


# Documentación de la API
## REST
             Prefix Verb   URI Pattern                    Controller#Action
           payments GET    /payments(.:format)            payments#index
            payment GET    /payments/:id(.:format)        payments#show
    payment_methods GET    /payment_methods(.:format)     payment_methods#index
                    POST   /payment_methods(.:format)     payment_methods#create
     payment_method GET    /payment_methods/:id(.:format) payment_methods#show
                    DELETE /payment_methods/:id(.:format) payment_methods#destroy

## Rabbit

 - ```FANOUT auth/logout ```
 Escucha el mensage logout de auth para invalidar tokens
  - ```TOPIC order/order_validated ```
Escucha order_validated desde order e intenta si es posible procesar el pago asociado a la ordern
  - ```TOPIC payments/payment_state_update ```
 Envío de mensaje con la información del pago

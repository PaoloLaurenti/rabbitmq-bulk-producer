import Config

config :rabbitmq_bulk_producer,
  amqp_connection: [
    username: "guest",
    password: "guest",
    host: "rabbit",
    port: 5_672,
    virtual_host: "/",
    heartbeat: 30,
    connection_timeout: 10_000
  ]

config :rabbitmq_bulk_producer, :producer, %{
  publisher_confirms: false,
  publish_timeout: 0
  # exchanges: [
  #   %{name: "my_exchange", type: :direct, opts: [durable: true]}
  # ]
}

import_config "#{config_env()}.exs"

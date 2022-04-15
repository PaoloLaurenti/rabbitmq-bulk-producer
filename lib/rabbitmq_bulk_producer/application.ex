defmodule RabbitmqBulkProducer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Amqpx.Helper

  @impl true
  def start(_type, _args) do
    children = [
      Helper.manager_supervisor_configuration(
        Application.get_env(:rabbitmq_bulk_producer, :amqp_connection)
      ),
      Helper.producer_supervisor_configuration(
        Application.get_env(:rabbitmq_bulk_producer, :producer)
      )
    ]

    opts = [strategy: :one_for_one, name: RabbitmqBulkProducer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

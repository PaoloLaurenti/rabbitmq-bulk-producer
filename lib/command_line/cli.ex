defmodule Commandline.CLI do
  alias RabbitmqBulkProducer.Bulk

  @spec main([String.t()]) :: :ok
  def main([]) do
    print_usage()
  end

  def main(args) do
    options = [
      switches: [file: :string, exchange: :string, routing_key: :string, help: :boolean],
      aliases: [f: :file, e: :exchange, r: :routing_key, h: :help]
    ]

    {opts, _, _} = OptionParser.parse(args, options)

    if Keyword.has_key?(opts, :help) do
      print_usage()
    else
      csv_file_path = Keyword.get(opts, :file)
      exchange_name = Keyword.get(opts, :exchange, "")
      routing_key = Keyword.get(opts, :routing_key, "")
      bulk(csv_file_path, exchange_name, routing_key)
    end

    :ok
  end

  defp print_usage() do
    IO.puts("Usage: rabbitmq_bulk_producer [OPTIONS]...")
    IO.puts(~s/Options:
-f  --file        PATH      Path of the csv file containing messages to publish
-e  --exchange    NAME      Name of the RabbitMQ exchange where to publish messages to
-r  --routing_key NAME      Name of the routing key to use to publish messages via RabbitMQ

-h --help          Show this message and exit.
/)
  end

  defp bulk(csv_file_path, exchange_name, routing_key) do
    Bulk.run(csv_file_path, exchange_name, routing_key)
  end
end

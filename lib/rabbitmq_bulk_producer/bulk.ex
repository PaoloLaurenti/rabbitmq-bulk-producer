NimbleCSV.define(MyParser, escape: "\"")

defmodule RabbitmqBulkProducer.Bulk do
  @moduledoc false

  alias Amqpx.Gen.Producer

  @spec run(file_path :: String.t(), exchange :: String.t(), routing_key :: String.t()) :: :ok
  def run(file_path, exchange, routing_key) do
    file_path
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [payload] ->
      %{payload: :binary.copy(payload)}
    end)
    |> Stream.map(fn %{payload: payload} -> Poison.decode!(payload) end)
    |> Stream.map(fn payload -> send_payload(exchange, routing_key, payload) end)
    |> Enum.reduce(%{ok: 0, ko: 0}, fn result, acc ->
      if result == :ok do
        Map.update!(acc, :ok, fn x -> x + 1 end)
      else
        Map.update!(acc, :ko, fn x -> x + 1 end)
      end
    end)
    |> print_results()

    :ok
  end

  defp send_payload(exchange, routing_key, payload) do
    Producer.publish(exchange, routing_key, Poison.encode!(payload))
  end

  def print_results(%{ok: ok_count, ko: ko_counts}) do
    IO.puts("OK messages: #{ok_count} - KO messages: #{ko_counts}")
  end
end

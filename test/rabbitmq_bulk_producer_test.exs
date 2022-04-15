defmodule RabbitmqBulkProducerTest do
  use ExUnit.Case
  doctest RabbitmqBulkProducer

  test "greets the world" do
    assert RabbitmqBulkProducer.hello() == :world
  end
end

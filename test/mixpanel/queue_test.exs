defmodule Mixpanel.QueueTest do
  use ExUnit.Case
  use ExUnitProperties

  alias Mixpanel.Queue

  property "never overflows" do
    check all max <- positive_integer(),
              count <- positive_integer(),
              list <- list_of(:item, length: count) do
      queue = new_with_list(list, max)
      assert Queue.length(queue) <= max
    end
  end

  property "preserves order" do
    check all count <- positive_integer(),
              list <- list_of(integer(), length: count),
              batch_size <- integer(1..(count + 1)) do
      queue = new_with_list(list)
      batches = take_all(queue, batch_size)
      assert List.flatten(batches) == list
    end
  end

  defp new_with_list(list, max \\ nil)

  defp new_with_list(list, nil) do
    new_with_list(list, length(list))
  end

  defp new_with_list(list, max) do
    Enum.reduce(list, Queue.new(), fn item, queue ->
      case Queue.push(queue, item, max) do
        {:ok, queue} ->
          queue

        :dropped ->
          queue
      end
    end)
  end

  defp take_all(queue, batch_size, acc \\ []) do
    case Queue.take(queue, batch_size) do
      {:ok, [], _} ->
        Enum.reverse(acc)

      {:ok, batch, queue} ->
        take_all(queue, batch_size, [batch | acc])
    end
  end
end

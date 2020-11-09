defmodule Mixpanel.Queue do
  def new(limit), do: {0, limit, [], []}

  def push({len, limit, _, _}, _item) when len >= limit do
    :dropped
  end

  def push({len, limit, tail, head}, item) do
    {:ok, {len + 1, limit, [item | tail], head}}
  end

  def take({len, limit, [], head}, max) do
    case Enum.split(head, max) do
      {result, []} ->
        {:ok, result, {0, limit, [], []}}

      {result, new_head} ->
        {:ok, result, {len - max, limit, [], new_head}}
    end
  end

  def take({len, limit, tail, head}, max) do
    take({len, limit, [], head ++ Enum.reverse(tail)}, max)
  end

  def length({len, _, _, _}), do: len
end

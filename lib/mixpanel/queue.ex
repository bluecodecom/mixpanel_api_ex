defmodule Mixpanel.Queue do
  def new, do: {0, [], []}

  def push({len, _, _}, _item, limit) when len >= limit do
    :dropped
  end

  def push({len, tail, head}, item, _limit) do
    {:ok, {len + 1, [item | tail], head}}
  end

  def take({len, [], head}, max) do
    case Enum.split(head, max) do
      {result, []} ->
        {:ok, result, {0, [], []}}

      {result, new_head} ->
        {:ok, result, {len - max, [], new_head}}
    end
  end

  def take({len, tail, head}, max) do
    take({len, [], head ++ Enum.reverse(tail)}, max)
  end

  def length({len, _, _}), do: len
end

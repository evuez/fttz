defmodule FTTZ do
  @hours 0..23
  @daytime 8..20

  def stats(screen_name, scale \\ :log10) do
    data = screen_name |> times

    data |> timezone

    IO.puts "\nTweet distribution throughout the day (at UTC±00:00):\n"

    data |> graph(scale)
  end

  defp times(screen_name) do
    timeline(screen_name)
    |> Stream.map(&extract_hour/1)
    |> Enum.reduce(%{}, &group_hours/2)
  end

  defp timeline(screen_name) do
    ExTwitter.user_timeline([screen_name: screen_name, include_rts: true, count: 200])
  end

  defp extract_hour(%{created_at: created_at} = _tweet) do
    FTTZ.Time.string_to_time(created_at).hour
  end

  defp group_hours(hour, acc), do: Map.update(acc, hour, 1, fn x -> x + 1 end)

  defp graph(data, :linear) do
    hours = @hours
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(&(String.pad_leading(&1, 2, "0")))
    |> Enum.join(" ")

    max_count = data |> Map.values |> Enum.max

    rows = for v <- 0..max_count do
      for h <- @hours do
        case max(0, (data[h] || 0) - v) do
          0 -> "  "
          _ -> "██"
        end
      end
      |> Enum.join(" ")
    end

    IO.puts hours
    Enum.each(rows, &IO.puts/1)
  end
  defp graph(data, :log10) do
    data
    |> Enum.map(fn {k, v} -> {k, round(:math.log10(v) * 10)} end)
    |> Enum.into(%{})
    |> graph(:linear)
  end

  defp timezone(data) do
    offset = data |> shift_to_daytime

    # Not sure if that makes sense.
    # Probably not since UTC spans over 26 offsets, not 24.
    # Anyway, it's an OK approximation for this module.
    offset = if offset > 12 do
      (-offset + 23)
      |> Integer.to_string
      |> String.pad_leading(2, "0")
      |> String.pad_leading(3, "+")
    else
      offset
      |> Integer.to_string
      |> String.pad_leading(2, "0")
      |> String.pad_leading(3, "-")
    end

    IO.puts "Most likely time offset is UTC#{offset}:00"
  end

  defp shift_to_daytime(data), do: shift_to_daytime(data, 0, {0, 0})
  defp shift_to_daytime(_data, 23, {best_iter, _}), do: best_iter
  defp shift_to_daytime(data, iter, best = {_, best_count}) do
    count = daytime_count(data)
    best = if count > best_count, do: {iter, count}, else: best

    shift_to_daytime(data |> shift_left, iter + 1, best)
  end

  defp daytime_count(data) do
    Enum.reduce(@daytime, 0, fn (hour, acc) -> acc + Map.get(data, hour, 0) end)
  end

  defp shift_left(data) do
    data
    |> Enum.map(fn {k, v} -> {if(k - 1 < 0, do: 23, else: k - 1), v} end)
    |> Enum.into(%{})
  end
end

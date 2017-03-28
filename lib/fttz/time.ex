defmodule FTTZ.Time do
  @moduledoc """
  Basic time extractor from Twitter datetime format.
  """

  def string_to_time(string) do
    <<_weekday::binary-size(3), " ",
      _month::binary-size(3), " ",
      _day::binary-size(2), " ",
      time::binary-size(8), " +0000 ",
      _year::binary-size(4)>> = string

    Time.from_iso8601!(time)
  end
end

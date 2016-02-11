defmodule Bot.Parse do
  def reduce_recent_reply(%{acc: acc, index: index, title: title, price: price,
                            p_id: p_id, time_created: time_created}) do
    IO.iodata_to_binary([acc, index, ":\n",
                          "[Title]: ", title, "\n",
                          "[Price]: ", price, "\n",
                          "[URL]: https://carousell.com/p/", p_id, "\n",
                          "[Time Created]: ", time_created, "\n"])
  end
end

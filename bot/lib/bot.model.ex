defmodule Bot.Model do

  defmodule CarousellProduct do
    defstruct title: nil, price: nil, id: nil, time_created: nil
    @type t :: %CarousellProduct{title: binary, price: binary, id: integer, time_created: binary}
  end

end

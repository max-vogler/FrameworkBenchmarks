defmodule Fortune do
  use Ecto.Schema

  @derive {Poison.Encoder, only: [:id, :message]}
  schema "fortune" do
    field :message, :string
  end

end

defmodule World do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:id, :randomnumber]}
  schema "world" do
    field :randomnumber, :integer
  end

  @required_fields ~w(randomnumber)a
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
  end
end

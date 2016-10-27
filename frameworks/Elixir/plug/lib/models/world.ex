defmodule World do
  use Ecto.Schema

  @derive {Poison.Encoder, only: [:id, :randomnumber]}
  schema "world" do
    field :randomnumber, :integer
  end

  @select "SELECT id, randomnumber FROM world WHERE id = $1"
  def prepare_select(db), do: Postgrex.prepare!(db, "", @select)

  @batch_update """
    UPDATE world
    SET randomnumber = data.rand
    FROM (SELECT UNNEST($1::int[]) AS id, UNNEST($2::int[]) AS rand) AS data
    WHERE world.id = data.id
  """
  def prepare_batch_update(db), do: Postgrex.prepare!(db, "", @batch_update)
end

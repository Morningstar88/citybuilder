Postgrex.Types.define(Citybuilder.PostgrexTypes,
  [
    {Citybuilder.Ltree, :copy},
    {Citybuilder.Lquery, :copy}
  ] ++ Ecto.Adapters.Postgres.extensions(),
  json: Poison
)

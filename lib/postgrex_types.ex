Postgrex.Types.define(LiveStory.PostgrexTypes,
  [
    {LiveStory.Ltree, :copy},
    {LiveStory.Lquery, :copy}
  ] ++ Ecto.Adapters.Postgres.extensions(),
  json: Poison
)

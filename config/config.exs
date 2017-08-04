# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :citybuilder,
  namespace: LiveStory,
  ecto_repos: [LiveStory.Repo]

# Configures the endpoint
config :citybuilder, LiveStory.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "24+YDGnqGmC2RuzHf7A97zLR+aGBNSF5K3Xd7plhIF3nUDTuqHdXrYGs1MHHgbL7",
  render_errors: [view: LiveStory.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveStory.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Citybuilder",
  ttl: { 3, :days },
  verify_issuer: true,
  serializer: LiveStory.Auths.GuardianSerializer,
  allowed_algos: ["ES512"],
  secret_key: %{
    "crv" => "P-521",
    "d" => "axDuTtGavPjnhlfnYAwkHa4qyfz2fdseppXEzmKpQyY0xd3bGpYLEF4ognDpRJm5IRaM31Id2NfEtDFw4iTbDSE",
    "kty" => "EC",
    "x" => "AL0H8OvP5NuboUoj8Pb3zpBcDyEJN907wMxrCy7H2062i3IRPF5NQ546jIJU3uQX5KN2QB_Cq6R_SUqyVZSNpIfC",
    "y" => "ALdxLuo6oKLoQ-xLSkShv_TA0di97I9V92sg1MKFava5hKGST1EKiVQnZMrN3HO8LtLT78SNTgwJSQHAXIUaA-lV"
  }


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

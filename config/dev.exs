use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :citybuilder, LiveStory.Web.Endpoint,
  http: [port: 8080],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :citybuilder, LiveStory.Web.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/citybuilder/web/views/.*(ex)$},
      ~r{lib/citybuilder/web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :citybuilder, LiveStory.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: LiveStory.PostgrexTypes,
  username: "postgres",
  password: "postgres",
  database: "citybuilder_dev",
  hostname: "localhost",
  template: "template0",
  pool_size: 10

# this will work only on localhost, please don't try to use this in production
config :recaptcha,
  public_key: "6Lfd0yMUAAAAALrGE9Y2WVnciARoQ6ZGqnl3FZTS",
  secret: "6Lfd0yMUAAAAAPjaO9NbiUX9S-5U4zq1ZVI-HpdH"

config :arc,
  storage: Arc.Storage.Local

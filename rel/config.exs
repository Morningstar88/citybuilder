# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :prod  #Changed from Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"N^`3TjP}(Ih|i1y!::ADyj>,FP[{h$N}$0ZWpSOfTOYJ^F7<yd<CzLu`<C;peA*1"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"=O4MmD;EzUTae|V6s>AB{u(H$h;*;|mhgSmgDxRe>v>}!Qx[YUs*n^Z@u17%&(n$"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :citybuilder do
  set version: current_version(:citybuilder)
end


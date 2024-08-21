import Config

config :logger, level: :info

config :read_me, ReadMeWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :read_me, domain: "https://jarrodtaylor.me"
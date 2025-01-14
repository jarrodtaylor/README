import Config

config :elixir, time_zone_database: Tzdata.TimeZoneDatabase

config :esbuild,
	version: "0.17.11",
	read_me: [
		args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets
			--external:/fonts/* --external:/images/*),
		cd: Path.expand("../assets", __DIR__),
		env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)} ]

config :logger, :console,
	format: "$time $metadata[$level] $message\n",
	metadata: [:request_id]

config :phoenix, json_library: Jason

config :read_me, ReadMeWeb.Endpoint,
	url: [host: "localhost"],
	adapter: Bandit.PhoenixAdapter,
	render_errors: [
		formats: [html: ReadMeWeb.ErrorHTML, json: ReadMeWeb.ErrorJSON],
		layout: false ],
	pubsub_server: ReadMe.PubSub,
	live_view: [signing_salt: "4rESmtSW"]

config :read_me,
	generators: [timestamp_type: :utc_datetime],
	time_zone: "America/New_York"

import_config "#{config_env()}.exs"
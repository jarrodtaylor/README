import Config

config :logger, :console, format: "[$level] $message\n"

config :phoenix,
	plug_init_mode: :runtime,
	stacktrace_depth: 20

config :phoenix_live_view,
	debug_heex_annotations: true,
	enable_expensive_runtime_checks: true

config :read_me, ReadMeWeb.Endpoint,
		http: [ip: {127, 0, 0, 1}, port: 4000],
		check_origin: false,
		code_reloader: true,
		debug_errors: false,
		secret_key_base: "2DtqOFOgAFQEL1CTDB4sv90J2QzNJpZfyyiptK4d64esOw5g5w4uWfxOQDIeHu88",
		watchers: [esbuild: {Esbuild, :install_and_run, [:read_me, ~w(--sourcemap=inline --watch)]}]

config :read_me, ReadMeWeb.Endpoint,
	live_reload: [
	patterns: [
		~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
		~r"priv/weblog/.*\.md",
		~r"lib/readme_web/(controllers|live|components|errors|pages|weblog)/.*(ex|eex|heex)$" ] ]

config :read_me,
	cache_control: "public, max-age=0",
	dev_routes: true
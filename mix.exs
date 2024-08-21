defmodule ReadMe.MixProject do
	use Mix.Project

	def project do
		[
			app: :read_me,
			version: "0.0.0",
			elixir: "~> 1.17",
			elixirc_paths: elixirc_paths(Mix.env()),
			start_permanent: Mix.env() == :prod,
			aliases: aliases(),
			deps: deps()
		]
	end

	def application do
		[
			mod: {ReadMe.Application, []},
			extra_applications: [:logger, :runtime_tools]
		]
	end

	defp elixirc_paths(_), do: ["lib"]

	defp deps do
		[
			{:phoenix, "~> 1.7.14"},
			{:phoenix_html, "~> 4.1"},
			{:phoenix_live_reload, "~> 1.2", only: :dev},
			{:phoenix_live_view, "~> 1.0.0-rc.1", override: true},
			{:floki, ">= 0.30.0", only: :test},
			{:phoenix_live_dashboard, "~> 0.8.3"},
			{:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
			{:telemetry_metrics, "~> 1.0"},
			{:telemetry_poller, "~> 1.0"},
			{:jason, "~> 1.2"},
			{:dns_cluster, "~> 0.1.1"},
			{:bandit, "~> 1.5"}
		]
	end

	defp aliases do
		[
			setup: ["deps.get", "assets.setup", "assets.build"],
			"assets.setup": ["esbuild.install --if-missing"],
			"assets.build": ["esbuild read_me"],
			"assets.deploy": ["esbuild read_me --minify", "phx.digest"]
		]
	end
end
defmodule ReadMe.Application do
	use Application
	
	@impl true
	def start(_type, _args) do
		children = [
			ReadMeWeb.Telemetry,
			{DNSCluster, query: Application.get_env(:read_me, :dns_cluster_query) || :ignore},
			{Phoenix.PubSub, name: ReadMe.PubSub},
			ReadMeWeb.Endpoint,
			ReadMe.Weblog.Repo ]
		
		opts = [strategy: :one_for_one, name: ReadMe.Supervisor]
		Supervisor.start_link(children, opts)
	end
	
	@impl true
	def config_change(changed, _new, removed) do
		ReadMeWeb.Endpoint.config_change(changed, removed)
		:ok
	end
end
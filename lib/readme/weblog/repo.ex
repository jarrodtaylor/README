defmodule ReadMe.Weblog.Repo do
	use GenServer
	
	alias ReadMe.Weblog.Article
	
	def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
	
	def init(args) do
		:ets.new(:weblog, [:set, :public, :named_table])
		{:ok, args}
	end
	
	def all do
		fn ->
			"#{ReadMe.weblog_dir}/**/*.md"
			|> Path.wildcard
			|> Enum.map(&Article.compile/1)
		end
		|> _cache(:all)
	end
	
	defp _cache(query, key) do
		case :ets.lookup(:weblog, key) do
			[] ->
				data = query.()
				:ets.insert(:weblog, {key, data})
				data
			
			[{_key, data}] -> data
		end
	end
end
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
			|> Enum.sort(&(&1.published >= &2.published))
		end
		|> _cache(:all)
	end
	
	def feed do
		fn ->
			__MODULE__.all
			|> Enum.take(100)
			|> Enum.map(&(%Article{&1 | updated: if(&1.updated, do: &1.updated, else: &1.published)}))
		end
		|> _cache(:feed)
	end
	
	def index do
		fn ->
			__MODULE__.all
			|> Enum.filter(&(&1.source == nil))
			|> Enum.map(fn article ->
				%{
					href: article.href,
					published: article.published,
					title: article.title,
					updated: article.updated
				}
			end)
			|> Enum.group_by(&Date.beginning_of_month(&1.published))
			|> Enum.reverse
		end
		|> _cache(:index)
	end
	
	def recents do
		fn ->
			__MODULE__.all
			|> Enum.take(100)
			|> Enum.group_by(&DateTime.to_date(&1.published))
			|> Enum.reverse
		end
		|> _cache(:recents)
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
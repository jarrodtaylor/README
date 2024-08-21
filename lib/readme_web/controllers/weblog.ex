defmodule ReadMeWeb.WeblogController do
	use ReadMeWeb, :controller
	
	alias ReadMe.Weblog.Repo
	
	def feed(conn, _params) do
		conn
		|> put_resp_content_type("application/atom+xml")
		|> render("weblog.xml", articles: Repo.all)
	end
	
	def index(conn, _params) do
		render(conn, :index)
	end

	def recents(conn, _params) do
		render(conn, :articles, articles: Repo.recents, style: "weblog articles")
	end
end

defmodule ReadMeWeb.WeblogHTML do
	use ReadMeWeb, :html
	
	def article(assigns) do
		~H"""
		<article class={if @article.source, do: "link", else: "column"}>
			<h2 :if={@article.source}>
				<.link href={@article.source}><%= @article.title %></.link>
				<.link :if={!Map.has_key?(assigns, :canonical)} href={@article.href}>&#8734;</.link>
			</h2>
			<h2 :if={@article.source == nil && Map.has_key?(assigns, :canonical)}>
				<%= @article.title %>
			</h2>
			<h2 :if={@article.source == nil && !Map.has_key?(assigns, :canonical)}>
				<.link href={@article.href}><%= @article.title %></.link>
			</h2>
			<.time :if={@article.source == nil} date={@article.published} format={"%A, %B %d, %Y"} />
			<%= raw(@article.html) %>
			<.time :if={@article.source != nil && Map.has_key?(assigns, :canonical)}
				date={@article.published}
				format={"%A, %B %d, %Y"} />
		</article>
		"""
	end
	
	def articles(assigns) do
		if assigns.articles == [] do
			~H"""
			<h2 class="error">Nothing to see here, move along.</h2>
			"""
		else
			~H"""
			<section :for={{date, articles} <- @articles}>
				<.time relative date={date} format={"%A, %B %d, %Y"} />
				<.article :for={article <- articles} article={article} />
			</section>
			"""
		end
	end
	
	def index(assigns) do
		~H"""
		Index
		"""
	end
end

defmodule ReadMeWeb.WeblogXML do
	use ReadMeWeb, :html
	
	embed_templates "../feeds/*"
	
	defp format_date(date), do: DateTime.to_iso8601(date)
end
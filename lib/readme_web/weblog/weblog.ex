defmodule ReadMeWeb.WeblogController do
	use ReadMeWeb, :controller
	
	alias ReadMe.Weblog.Repo
	
	def archive(conn, %{"year" => year, "month" => month}) do
		date = "#{year}-#{month}-01"
		|> Date.from_iso8601!
		|> Calendar.strftime("%b %Y")
	
		render(conn, :articles,
			articles: Repo.archive(year, month),
			page_title: "Weblog ∈ #{date}",
			style: "weblog articles")
	end
	
	def article(conn, %{"year" => year, "month" => month, "slug" => slug}) do
		case Repo.article(ReadMeWeb.url("/weblog/#{year}/#{month}/#{slug}")) do
			nil -> _not_found(conn)
			article -> _article(conn, article)
		end
	end
	
	def feed(conn, _params), do: conn
		|> put_resp_content_type("application/atom+xml")
		|> render("weblog.xml", articles: Repo.all)
	
	def index(conn, _params), do: render(conn, :index,
		articles: Repo.index,
		page_title: "Weblog",
		style: "weblog index")
	
	def linked(conn, %{"year" => year, "month" => month, "slug" => slug}) do
		case Repo.article(ReadMeWeb.url("/weblog/linked/#{year}/#{month}/#{slug}")) do
			nil -> _not_found(conn)
			article -> _article(conn, article)
		end
	end
	
	def recents(conn, _params), do: render(conn, :articles,
		articles: Repo.recents,
		style: "weblog articles")
	
	defp _article(conn, article), do: render(conn, :article,
		article: article,
		page_title: "#{article.title}",
		style: "weblog article",
		canonical: nil)
	
	defp _not_found(conn), do: conn
		|> put_status(:not_found)
		|> put_root_layout(false)
		|> put_layout(false)
		|> put_view(ReadMeWeb.ErrorHTML)
		|> render(:"404")
end

defmodule ReadMeWeb.WeblogHTML do
	use ReadMeWeb, :html
	
	def article(assigns), do:
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
	
	def articles(assigns), do:
		~H"""
		<h2 :if={@articles == []} class="error">Nothing to see here, move along.</h2>
		<section :for={{date, articles} <- @articles}>
			<.time relative date={date} format={"%A, %B %d, %Y"} />
			<.article :for={article <- articles} article={article} />
		</section>
		"""
	
	def index(assigns), do:
		~H"""
		<section :for={{month, articles} <- @articles}>
			<.link href={"/weblog/archive/#{Calendar.strftime(month, "%Y/%m")}"}>
				<.time date={month} format={"%B %Y"} />
			</.link>
			<ul>
				<li :for={article <- articles}>
					<.link href={raw(article.href)}><%= article.title %></.link>
					<.time relative date={article.published} format={"%A, %B %d, %Y"} />
				</li>
			</ul>
		</section>
		"""
end

defmodule ReadMeWeb.WeblogXML do
	use ReadMeWeb, :html
	embed_templates "feeds/*"
	defp format_date(date), do: DateTime.to_iso8601(date)
end
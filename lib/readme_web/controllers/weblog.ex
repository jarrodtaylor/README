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
		render(conn, :articles)
	end
end

defmodule ReadMeWeb.WeblogHTML do
	use ReadMeWeb, :html
	
	def articles(assigns) do
		~H"""
		Articles
		"""
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
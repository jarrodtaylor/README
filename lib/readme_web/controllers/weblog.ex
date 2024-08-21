defmodule ReadMeWeb.WeblogController do
	use ReadMeWeb, :controller
	
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
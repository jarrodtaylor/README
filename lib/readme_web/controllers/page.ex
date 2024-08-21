defmodule ReadMeWeb.PageController do
	use ReadMeWeb, :controller
	def home(conn, _params), do: render(conn, :home, layout: false)
end

defmodule ReadMeWeb.PageHTML do
	use ReadMeWeb, :html;
	embed_templates "../pages/*"
end
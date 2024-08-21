defmodule ReadMeWeb.PageController do
	use ReadMeWeb, :controller
	def readme(conn, _params), do: render(conn, :readme, page_title: "README")
end

defmodule ReadMeWeb.PageHTML do
	use ReadMeWeb, :html
	embed_templates "templates/*"
end
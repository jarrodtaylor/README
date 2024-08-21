defmodule ReadMeWeb.ErrorHTML do
	use ReadMeWeb, :html
	embed_templates "templates/*"
	def render(template, _assigns), do: Phoenix.Controller.status_message_from_template(template)
end
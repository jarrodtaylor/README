defmodule ReadMeWeb do
	def url(path), do: (ReadMe.config(:domain) || ReadMeWeb.Endpoint.url) <> path
	
	def static_paths, do: ~w(assets downloads fonts images favicon.ico robots.txt)
	
	def router do
		quote do
			use Phoenix.Router, helpers: false
			import Plug.Conn
			import Phoenix.Controller
			import Phoenix.LiveView.Router
		end
	end
	
	def channel do
		quote do
			use Phoenix.Channel
		end
	end
	
	def controller do
		quote do
			use Phoenix.Controller,
				formats: [:html, :json],
				layouts: [html: ReadMeWeb.Layouts]
			import Plug.Conn
			unquote(verified_routes())
		end
	end
	
	def live_view do
		quote do
			use Phoenix.LiveView, layout: {ReadMeWeb.Layouts, :app}
			unquote(html_helpers())
		end
	end
	
	def live_component do
		quote do
			use Phoenix.LiveComponent
			unquote(html_helpers())
		end
	end
	
	def html do
		quote do
			use Phoenix.Component
			import Phoenix.Controller, only: [get_csrf_token: 0, view_module: 1, view_template: 1]
			unquote(html_helpers())
		end
	end
	
	defp html_helpers do
		quote do
			import Phoenix.HTML
			import ReadMeWeb.CoreComponents
			alias Phoenix.LiveView.JS
			unquote(verified_routes())
		end
	end
	
	def verified_routes do
		quote do
			use Phoenix.VerifiedRoutes,
				endpoint: ReadMeWeb.Endpoint,
				router: ReadMeWeb.Router,
				statics: ReadMeWeb.static_paths()
		end
	end
	
	defmacro __using__(which) when is_atom(which), do: apply(__MODULE__, which, [])
end
defmodule ReadMeWeb.Router do
	use ReadMeWeb, :router
	
	pipeline :browser do
		plug :accepts, ["html"]
		plug :fetch_session
		plug :fetch_live_flash
		plug :put_root_layout, html: {ReadMeWeb.Layouts, :root}
		plug :protect_from_forgery
		plug :put_secure_browser_headers
	end
	
	scope "/", ReadMeWeb do
		pipe_through :browser
		
		get "/", PageController, :home
	end
	
	if Application.compile_env(:read_me, :dev_routes) do
		import Phoenix.LiveDashboard.Router
		
		scope "/dev" do
			pipe_through :browser
			live_dashboard "/dashboard", metrics: ReadMeWeb.Telemetry
		end
	end
end
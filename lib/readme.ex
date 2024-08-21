defmodule ReadMe do
	def config(key), do: Application.get_env(:read_me, key)
	def config(key, default), do: Application.get_env(:read_me, key, default)

	def weblog_dir, do: Application.app_dir(:read_me, "priv/weblog")
end
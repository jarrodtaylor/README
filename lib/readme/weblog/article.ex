defmodule ReadMe.Weblog.Article do
	defstruct [:href, :html, :published, :source, :title, :updated]
	
	def compile(path) do
		{yaml, html} = _read(path)
		
		%__MODULE__{
			href: _href(path),
			html: html,
			published: _frontmatter(yaml, "published") |> _as_date,
			source: _frontmatter(yaml, "source"),
			title: _frontmatter(yaml, "title"),
			updated: _frontmatter(yaml, "updated") |> _as_date }
	end
	
	defp _as_date(date) do
		case date do
			nil -> nil
			date -> date
			|> NaiveDateTime.from_iso8601!
			|> DateTime.from_naive!(ReadMe.config(:time_zone))
		end
	end
	
	defp _frontmatter(yaml, key) do
		case :proplists.get_value(String.to_charlist(key), yaml) do
			:undefined -> nil
			value -> to_string(value)
		end
	end
	
	defp _href(path), do: path
		|> String.replace(ReadMe.weblog_dir, ReadMeWeb.url("/weblog"))
		|> String.replace(".md", "")
	
	defp _read(path) do
		[yaml, md] = path
		|> File.read!
		|> String.split("\n---\n", parts: 2)
		
		yaml = yaml
		|> :yamerl_constr.string
		|> Enum.at(0)
		
		html = md
		|> String.trim
		|> Earmark.as_html!(sub_sup: true)
		
		{yaml, html}
	end
end
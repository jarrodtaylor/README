defmodule ReadMeWeb.CoreComponents do
	use Phoenix.Component
	# alias Phoenix.LiveView.JS

	def time(assigns) do
		~H"""
		<time datetime={@date}>
			<%= if Map.has_key?(assigns, :relative),
				do: relative_date(@date, @format),
				else: Calendar.strftime(@date, @format) %>
		</time>
		"""
	end
	
	defp relative_date(date, format) do
		current_date = DateTime.utc_now |> DateTime.shift_zone!(ReadMe.config(:time_zone))
		today = current_date |> Calendar.strftime("%x")
		yesterday = current_date |> Date.shift(day: -1) |> Calendar.strftime("%x")
	
		case Calendar.strftime(date, "%x") do
			^today -> "Today"
			^yesterday -> "Yesterday"
			_ -> Calendar.strftime(date, format)
		end
	end
end
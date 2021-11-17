defmodule Mix.Tasks.Ver.Get do
  @shortdoc "Get version number"

  use Mix.Task

  @spec run(command_line_args :: [binary]) :: :ok
  def run(_args) do
    content = File.read!("mix.exs")
    [_full, app] = Regex.run(~r|app: :(\w+)|, content)

    [_full, major, minor, patch] =
      Regex.run(~r|version: "(\d+)\.(\d+)\.(\d+)"|, content)

    version = "#{major}.#{minor}.#{patch}"

    [:light_green, "* #{app} #{version}"]
    |> IO.ANSI.format()
    |> IO.puts()

    IO.puts(Mix.Project.config()[:version])
  end
end

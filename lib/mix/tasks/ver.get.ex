defmodule Mix.Tasks.Ver.Get do
  @shortdoc "Get version number"

  use Mix.Task

  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    content = File.read!("mix.exs")
    [[_full, app]] = Regex.scan(~r[app: :(\w+)], content)

    [[_full, major, minor, patch]] =
      Regex.scan(~r[version: "(\d+)\.(\d+)\.(\d+)"], content)

    version = "#{major}.#{minor}.#{patch}"

    [:light_green, "* #{app} #{version}"]
    |> IO.ANSI.format()
    |> IO.puts()
  end
end

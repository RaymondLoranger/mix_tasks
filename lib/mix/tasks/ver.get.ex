defmodule Mix.Tasks.Ver.Get do
  use Mix.Task

  @shortdoc "Get version number"

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
  end

  @spec ver(Path.t()) :: String.t()
  def ver(folder) do
    content = File.read!("#{folder}/mix.exs")

    [_full, major, minor, patch] =
      Regex.run(~r|version: "(\d+)\.(\d+)\.(\d+)"|, content)

    "#{major}.#{minor}.#{patch}"
  end

  @spec hex?(Path.t()) :: boolean
  def hex?(folder) do
    content = File.read!("#{folder}/mix.exs")
    if Regex.run(~r|package: \w+|, content), do: true, else: false
  end
end

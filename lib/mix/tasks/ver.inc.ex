defmodule Mix.Tasks.Ver.Inc do
  @shortdoc "Increment patch version"

  use Mix.Task

  @spec run(command_line_args :: [binary]) :: :ok
  def run(_args) do
    content = File.read!("mix.exs")

    [full, major, minor, patch] =
      Regex.run(~r|version: "(\d+)\.(\d+)\.(\d+)"|, content)

    new_version = "#{major}.#{minor}.#{String.to_integer(patch) + 1}"
    new_content = String.replace(content, full, ~s|version: "#{new_version}"|)
    File.write!("mix.exs", new_content)
  end
end

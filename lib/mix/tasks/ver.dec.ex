defmodule Mix.Tasks.Ver.Dec do
  @shortdoc "Decrement patch version"

  use Mix.Task

  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    content = File.read!("mix.exs")
    [[_full, app]] = Regex.scan(~r[app: :(\w+)], content)

    [[full, major, minor, patch]] =
      Regex.scan(~r[version: "(\d+)\.(\d+)\.(\d+)"], content)

    new_version = "#{major}.#{minor}.#{String.to_integer(patch) - 1}"
    new_content = String.replace(content, full, ~s[version: "#{new_version}"])
    File.write!("mix.exs", new_content)

    [:light_green, "* #{app} #{new_version}"]
    |> IO.ANSI.format()
    |> IO.puts()
  end
end

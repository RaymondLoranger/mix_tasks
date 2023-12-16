defmodule Mix.Tasks.Ver do
  @moduledoc "Prints the app version."

  @shortdoc "Prints the app version"

  use Mix.Task

  @doc """
  Prints the app version.

  ## Examples

      mix ver # => will print the app version in light green as '* app 0.1.2'
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    app = Mix.Project.config()[:app]
    %Version{} = version = Mix.Project.config()[:version] |> Version.parse!()
    [:light_green, "* #{app} #{version}"] |> IO.ANSI.format() |> IO.puts()
  end
end

defmodule Mix.Tasks.Ver do
  @moduledoc "Prints and returns the app version."

  @shortdoc "Prints and returns the app version"

  use Mix.Task

  @doc """
  Prints and returns the app version.

  ## Examples

      mix ver
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: Version.t()
  def run(_args) do
    app = Mix.Project.config()[:app]
    version = Mix.Project.config()[:version] |> Version.parse!()
    [:light_green, "* #{app} #{version}"] |> IO.ANSI.format() |> IO.puts()
    version
  end
end

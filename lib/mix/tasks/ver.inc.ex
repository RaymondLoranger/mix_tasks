defmodule Mix.Tasks.Ver.Inc do
  @moduledoc "Increments the app version."

  @shortdoc "Increments the app version"

  use Mix.Task

  @doc """
  Increments the app version.

  ## Examples

      mix ver.inc
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    version = Mix.Project.config()[:version] |> Version.parse!()
    new_version = %Version{version | patch: version.patch + 1}

    File.write!(
      "mix.exs",
      File.read!("mix.exs")
      |> String.replace(~s|"#{version}"|, ~s|"#{new_version}"|, global: false)
    )
  end
end

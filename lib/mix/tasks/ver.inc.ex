defmodule Mix.Tasks.Ver.Inc do
  @moduledoc "Increments and returns the app version."

  @shortdoc "Increments and returns the app version"

  use Mix.Task

  @doc """
  Increments and returns the app version.

  ## Examples

      mix ver.inc
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: Version.t()
  def run(_args) do
    version = Mix.Project.config()[:version] |> Version.parse!()
    new_version = %Version{version | patch: version.patch + 1}

    :ok =
      File.write!(
        "mix.exs",
        File.read!("mix.exs")
        |> String.replace(~s|"#{version}"|, ~s|"#{new_version}"|, global: false)
      )

    new_version
  end
end

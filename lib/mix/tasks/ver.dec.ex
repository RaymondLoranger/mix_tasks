defmodule Mix.Tasks.Ver.Dec do
  @moduledoc "Decrements and returns the app version."

  @shortdoc "Decrements and returns the app version"

  use Mix.Task

  @doc """
  Decrements and returns the app version.

  ## Examples

      mix ver.dec
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: Version.t()
  def run(_args) do
    version = Mix.Project.config()[:version] |> Version.parse!()
    new_version = %Version{version | patch: version.patch - 1}

    :ok =
      File.write!(
        "mix.exs",
        File.read!("mix.exs")
        |> String.replace(~s|"#{version}"|, ~s|"#{new_version}"|, global: false)
      )

    new_version
  end
end

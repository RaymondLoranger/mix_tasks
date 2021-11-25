defmodule Mix.Tasks.Ver.Dec do
  @moduledoc "Decrements the app version."

  @shortdoc "Decrements the app version"

  use Mix.Task

  @doc """
  Decrements the app version.

  ## Examples

      mix ver.dec
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    version = Mix.Project.config()[:version] |> Version.parse!()
    new_version = %Version{version | patch: version.patch - 1}

    File.write!(
      "mix.exs",
      File.read!("mix.exs")
      |> String.replace(~s|"#{version}"|, ~s|"#{new_version}"|, global: false)
    )
  end
end

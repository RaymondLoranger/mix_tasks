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
    %Version{} = version = Mix.Project.config()[:version] |> Version.parse!()
    new_version = update_in(version.patch, &(&1 + 1))

    File.write!(
      "mix.exs",
      "mix.exs"
      |> File.read!()
      |> String.replace(~s|"#{version}"|, ~s|"#{new_version}"|, global: false)
    )
  end
end

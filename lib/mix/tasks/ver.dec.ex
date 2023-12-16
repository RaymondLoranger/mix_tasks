defmodule Mix.Tasks.Ver.Dec do
  @moduledoc "Decrements the app version."

  @shortdoc "Decrements the app version"

  use Mix.Task

  @doc """
  Decrements the app version.

  ## Examples

      mix ver.dec # => will decrement the app version
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    %Version{} = version = Mix.Project.config()[:version] |> Version.parse!()
    new_version = update_in(version.patch, &(&1 - 1))

    File.write!(
      "mix.exs",
      "mix.exs"
      |> File.read!()
      |> String.replace(~s|"#{version}"|, ~s|"#{new_version}"|, global: false)
    )
  end
end

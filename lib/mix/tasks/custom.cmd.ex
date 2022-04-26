defmodule Mix.Tasks.Custom.Cmd do
  @moduledoc "Echoes and executes the given command."

  @shortdoc "Echoes and executes the given command"

  use Mix.Task

  @doc """
  Echoes and executes the given command.

  ## Examples

      mix custom.cmd ls --reverse
      mix custom.cmd mix deps
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(args) do
    Mix.Tasks.Echo.run(args)

    try do
      Mix.Tasks.Cmd.run(args)
    catch
      :exit, _reason -> :ok
    end
  end
end

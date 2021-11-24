defmodule Mix.Tasks.Echo do
  @moduledoc "Echoes the given command."

  @shortdoc "Echoes the given command"

  use Mix.Task

  @doc """
  Echoes the given command.

  ## Examples

      mix echo ls --reverse
      mix echo mix deps
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(args) do
    [:light_yellow, Enum.join(args, " ")] |> IO.ANSI.format() |> IO.puts()
  end
end

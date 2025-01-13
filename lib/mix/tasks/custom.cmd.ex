defmodule Mix.Tasks.Custom.Cmd do
  @moduledoc "Echoes and executes the given command."

  @shortdoc "Echoes and executes the given command"

  use Mix.Task

  @doc """
  Echoes and executes the given command.

  ## Examples

      mix custom.cmd git status # => will print 'git status' and run it
      mix custom.cmd mix deps # => will print 'mix deps' and run it
      mix custom.cmd dir # => will print 'dir' and run it
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(~w<git branch> = args) do
    Mix.Tasks.Echo.run(args)
    [bef, aft] = :os.cmd(~c"git branch") |> to_string() |> String.split("*")
    [bef, "*", :green, aft] |> IO.ANSI.format() |> IO.write()
  end

  def run(args) do
    Mix.Tasks.Echo.run(args)

    try do
      Mix.Tasks.Cmd.run(args)
    catch
      :exit, _reason -> :ok
    end
  end
end

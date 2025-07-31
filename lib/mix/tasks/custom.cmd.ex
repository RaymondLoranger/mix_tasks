defmodule Mix.Tasks.Custom.Cmd do
  @moduledoc "Echoes and executes the given command."

  @shortdoc "Echoes and executes the given command"

  use Mix.Task

  @doc """
  Echoes and executes the given command.

  ## Examples

      mix custom.cmd git status # => will print 'git status' and run it
      mix custom.cmd mix deps # => will print 'mix deps' and run it
      mix custom.cmd echo Hi # => will print 'echo Hi' and run it
      mix custom.cmd hostname # => will print 'hostname' and run it
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(~w<git branch> = args) do
    Mix.Tasks.Echo.run(args)

    # Example:
    # git branch
    #   elementary-watson
    # * improve-usage
    #   main
    [bef, aft] = "#{:os.cmd(~c"git branch")}" |> String.split("*")
    # => ["  elementary-watson\n", " improve-usage\n  main\n"]
    # bef = "  elementary-watson\n"
    # aft = " improve-usage\n  main\n"

    [cur, etc] = String.split(aft, "\n", parts: 2)
    # => [" improve-usage", "  main\n"]
    # cur = " improve-usage"
    # etc = "  main\n"

    [bef, ["*", :light_green, cur, :reset, "\n"], etc]
    # => [
    #      "  elementary-watson\n",
    #      ["*", :light_green, " improve-usage", :reset, "\n"],
    #      "  main\n"
    #    ]
    |> IO.ANSI.format()
    |> IO.write()

    # =>   elementary-watson
    #    * improve-usage
    #      main
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

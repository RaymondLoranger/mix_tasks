defmodule Mix.Tasks.Cln do
  @shortdoc "Clean, deps, dialyzer and hex outdated"

  use Mix.Task

  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    project = File.cwd!() |> Path.basename()
    Mix.Tasks.Cmd.run(~w/mix clean/)
    Mix.Tasks.Cmd.run(~w/mix deps.clean --all/)
    Mix.Tasks.Cmd.run(~w/mix deps.unlock --all/)
    Mix.Tasks.Cmd.run(~w/mix deps.get/)

    unless project == "mix_tasks" do
      Mix.Tasks.Cmd.run(~w/mix dialyzer/)
    end

    Mix.Tasks.Cmd.run(~w/mix deps/)

    try do
      Mix.Tasks.Cmd.run(~w/mix hex.outdated/)
    catch
      :exit, _reason -> :ok
    end
  end
end

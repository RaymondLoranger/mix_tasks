defmodule Mix.Tasks.Cln do
  @shortdoc "Clean, deps, dialyzer and hex outdated"

  use Mix.Task

  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    project = File.cwd!() |> Path.basename()
    Mix.Tasks.Cmd.run(~w/mix clean/)
    Mix.Tasks.Cmd.run(~w/mix deps.clean --all/)
    Mix.Tasks.Cmd.run(~w/mix deps.get/)
    Mix.Tasks.Cmd.run(~w/mix deps.update --all/)

    unless project == "mix_tasks" do
      Mix.Tasks.Cmd.run(~w/mix dialyzer/)
    end

    Mix.Tasks.Cmd.run(~w/mix deps/)
    Mix.Tasks.Cmd.run(~w/mix hex.outdated/)
  end
end

defmodule Mix.Tasks.Gen do
  @shortdoc "Format, compile, test, dialyzer and docs"

  use Mix.Task

  @spec run(OptionParser.argv()) :: :ok
  def run(args) do
    project = File.cwd!() |> Path.basename()
    unless "--no-format" in args, do: Mix.Tasks.Cmd.run(~w<mix format>)
    if "--inc" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.inc>)
    if "--dec" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.dec>)
    Mix.Tasks.Cmd.run(~w/mix compile/)
    Mix.Tasks.Cmd.run(~w/mix test/)

    unless project == "mix_tasks" do
      Mix.Tasks.Cmd.run(~w/mix dialyzer --no-check/)
      Mix.Tasks.Cmd.run(~w/mix docs/)
    end

    Mix.Tasks.Cmd.run(~w<mix ver.get>)
  end
end

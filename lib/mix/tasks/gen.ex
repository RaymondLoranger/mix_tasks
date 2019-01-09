defmodule Mix.Tasks.Gen do
  use Mix.Task

  @shortdoc "Format, compile, test, dialyzer and docs"

  @spec run(command_line_args :: [binary]) :: :ok
  def run(args) do
    unless "--no-format" in args, do: Mix.Tasks.Cmd.run(~w<mix format>)
    if "--inc" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.inc>)
    if "--dec" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.dec>)
    Mix.Tasks.Cmd.run(~w/mix compile/)
    Mix.Tasks.Cmd.run(~w/mix test/)
    Mix.Tasks.Cmd.run(~w/mix dialyzer --no-check/)
    Mix.Tasks.Cmd.run(~w/mix docs/)
    Mix.Tasks.Cmd.run(~w/mix deps.tree --format dot/)
    Mix.Tasks.Cmd.run(~w<mix ver.get>)
  end
end
